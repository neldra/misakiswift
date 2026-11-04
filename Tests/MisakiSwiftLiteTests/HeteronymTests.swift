import Testing
@testable import MisakiSwiftLite

// Upstream Misaki (en.py `Lexicon.lookup`) tries the exact Penn tag first
// (VBD/VBN/VBP/DT), then the parent tag (VERB/NOUN/ADJ/ADV), and uses the
// "None" key when no vowel follows (end of a clause). Expected phonemes below
// are the us_gold entries for each case.
//
// EnglishG2P is not safe to share across threads (NLTagger), so the suite is serialized.
@Suite(.serialized) struct HeteronymTests {
    let g2p = EnglishG2P(british: false)
    func ipa(_ text: String) -> String { g2p.phonemize(text: text).0 }

    // MARK: read (DEFAULT ɹˈid, VBD/VBN/VBP ɹˈɛd)

    @Test(arguments: [
        "He read the letter twice.",
        "She had read it before.",
        "The book was read aloud.",
        "He quickly read the note.",
    ])
    func pastRead(_ s: String) {
        #expect(ipa(s).contains("ɹˈɛd"), "\(s) → \(ipa(s))")
    }

    @Test(arguments: [
        "I want to read it.",
        "Read it now.",
        "You should never read it.",
        "Did you read it?",
    ])
    func baseRead(_ s: String) {
        let out = ipa(s)
        #expect(out.contains("ɹˈid") && !out.contains("ɹˈɛd"), "\(s) → \(out)")
    }

    @Test func pastReread() {
        #expect(ipa("She reread the page.").contains("ɹiɹˈɛd"))
    }

    // MARK: wound (DEFAULT wˈund, VBD/VBN/VBP wˈWnd)

    @Test func woundAsVerbAndNoun() {
        #expect(ipa("He wound the clock.").contains("wˈWnd"))
        #expect(ipa("The wound bled.").contains("wˈund"))
    }

    // MARK: that (DT ðˈæt)

    @Test func determinerThatIsStressed() {
        #expect(ipa("That book is mine.").contains("ðˈæt"))
    }

    // MARK: "None" key (stressed form at the end of a clause)

    @Test func clauseFinalFunctionWordUsesNoneKey() {
        #expect(ipa("That's what he has.").contains("hˈæz"))
        #expect(ipa("He used to go there.") == "hˌi jˈust tə ɡˌO ðˈɛɹ.")
        let mid = ipa("He has a dog.")
        #expect(mid.contains("hæz") && !mid.contains("hˈæz"), "\(mid)")
    }

    // MARK: Regressions (output already correct before this change)

    @Test(arguments: [
        ("He lives here.", "hˌi lˈɪvz hˈɪɹ."),
        ("A live wire.", "ɐ lˈIv wˈIəɹ."),
        ("The NSA called.", "ði ˌɛnˌɛsˈA kˈɔld."),
        ("It cost 3 dollars and 50 cents.", "ˌɪt kˈɔst θɹˈi dˈɑləɹz ænd fˈɪfti sˈɛnts."),
        ("The Spell whispered in his mind.", "ðə spˈɛl wˈɪspəɹd ɪn hɪz mˈInd."),
        ("Who are you talking to?", "hˌu ɑɹ ju tˈɔkɪŋ tu?"),
    ])
    func unchangedSentences(_ input: String, _ expected: String) {
        #expect(ipa(input) == expected)
    }

    // MARK: Lexicon coverage (entries present in upstream us_silver)

    @Test(arguments: [
        ("ancients", "ˈAnʧənts"),
        ("limbic", "lˈɪmbɪk"),
        ("snaggletoothed", "snˈæɡᵊltˌuθt"),
    ])
    func upstreamSilverEntriesPresent(_ word: String, _ expected: String) {
        #expect(ipa(word) == expected)
    }
}
