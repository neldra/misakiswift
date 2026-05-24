import Testing
@testable import MisakiSwiftLite

/// Regression: `EnglishNum2Word.midNumWords` was missing the (20, "twenty")
/// entry, so cardinals 21-29 came back as "-one", "-two", ..., "-nine" with
/// the tens word silently dropped. That fed into the year route, e.g.
/// toYear(2286) → "-two eighty-six" → IPA "tu eighty six" (heard as "286").
@Test func twentyIsSpokenInYears() async throws {
    let g2p = EnglishG2P(british: false)
    let (ipa2286, _) = g2p.phonemize(text: "2286")
    #expect(ipa2286.contains("twˈɛnti"), "year 2286 lost 'twenty': \(ipa2286)")

    let (ipa2024, _) = g2p.phonemize(text: "2024")
    let twentyMatches = ipa2024.components(separatedBy: "twˈɛnti").count - 1
    #expect(twentyMatches >= 2, "year 2024 should say 'twenty' twice, got: \(ipa2024)")
}
