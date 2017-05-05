import Foundation

class Regex{
  func firstMatch(_ pattern: String, data: String) -> String?{
    do{
      let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
      let matches = regex.matches(in: data, options: [], range: NSMakeRange(0, data.utf16.count)) as [NSTextCheckingResult]

      guard matches.count > 0 else { return nil }
      guard let firstMatch = matches.first else { return nil }
      guard firstMatch.numberOfRanges > 1 else { return nil }
      let matchedGroup = (data as NSString).substring(with: firstMatch.rangeAt(1))
      guard !matchedGroup.isEmpty else { return nil }
      return matchedGroup.trimmingCharacters(in: .whitespacesAndNewlines)
      
    } catch _ {
      return nil
    }
  }
}
