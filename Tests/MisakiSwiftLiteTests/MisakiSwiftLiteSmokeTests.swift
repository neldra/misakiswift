import Testing
@testable import MisakiSwiftLite

@Test func testFunctionWordsHitLexicon() async throws {
    let g2p = EnglishG2P(british: false)
    // Function words that the broken FluidAudio BART G2P pronounced as letter names.
    // All should have phoneme output (lexicon hit) — exact IPA is not asserted, only non-nil.
    for word in ["the", "a", "she", "I", "of", "to", "and", "is"] {
        let (ipa, tokens) = g2p.phonemize(text: word)
        #expect(!tokens.isEmpty, "no tokens for \(word)")
        #expect(!ipa.isEmpty, "empty IPA string for \(word)")
        // First non-whitespace token should have phonemes set.
        let primary = tokens.first { !$0.text.trimmingCharacters(in: .whitespaces).isEmpty }
        #expect(primary?.phonemes != nil, "\(word) should be in lexicon, got nil IPA")
    }
}

@Test func testOOVReturnsNilPhonemes() async throws {
    let g2p = EnglishG2P(british: false)
    // Pokémon proper nouns are not in the Misaki lexicon and FallbackNetwork is stripped.
    // Should return non-empty tokens with phonemes == nil so caller routes to its own G2P.
    let (_, tokens) = g2p.phonemize(text: "Rayquaza")
    let primary = tokens.first { !$0.text.trimmingCharacters(in: .whitespaces).isEmpty }
    #expect(primary != nil)
    #expect(primary?.phonemes == nil, "OOV should have nil phonemes; got \(String(describing: primary?.phonemes))")
}

@Test func testSentenceConcatenation() async throws {
    let g2p = EnglishG2P(british: false)
    let (ipa, _) = g2p.phonemize(text: "she walked into the room")
    #expect(!ipa.isEmpty)
}
