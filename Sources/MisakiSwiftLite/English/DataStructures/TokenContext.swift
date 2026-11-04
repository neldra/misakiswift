import Foundation
import NaturalLanguage

class TokenContext {
  var futureVowel: Bool?
  var futureTo: Bool
  /// Preceding words of the current token, used only to refine bare-verb Penn tags
  /// for heteronym lookup. Stop at punctuation when walking this list.
  var preceding: ArraySlice<(text: String, tag: NLTag?)>

  init(
    futureVowel: Bool? = nil,
    futureTo: Bool = false,
    preceding: ArraySlice<(text: String, tag: NLTag?)> = []
  ) {
    self.futureVowel = futureVowel
    self.futureTo = futureTo
    self.preceding = preceding
  }
}
