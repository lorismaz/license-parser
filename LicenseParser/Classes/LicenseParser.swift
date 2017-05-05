import Foundation

/// A Parser for creating ParsedLicense objects
open class Parser{
  let regex: Regex = Regex()

  /// The AAMVA PDF417 raw barcode data being used for parsing
  open var data: String

  /// The FieldParsing object to aide in parsing individual fields
  open var fieldParser: FieldParsing

  /**
    Initializes a new Parser

    - Parameters:
      - data: The AAMVA PDF417 raw barcode data

    - Returns: A configured Parser ready to parse and generate a ParsedLicense
  */
  public init(data: String){
    self.data = data
    self.fieldParser = FieldParser(data: data)
  }

  /**
    Parses the AAMVA PDF417 raw barcode data based on the specific AAMVA document version

    - Returns: A ParsedLicense with all available parsed fields
  */
  open func parse() -> ParsedLicense{
    self.fieldParser = versionBasedFieldParsing(parseVersion())

    return License(
      firstName               : fieldParser.parseFirstName(),
      lastName                : fieldParser.parseLastName(),
      middleName              : fieldParser.parseMiddleName(),
      expirationDate          : fieldParser.parseExpirationDate(),
      issueDate               : fieldParser.parseIssueDate(),
      dateOfBirth             : fieldParser.parseDateOfBirth(),
      gender                  : fieldParser.parseGender(),
      eyeColor                : fieldParser.parseEyeColor(),
      height                  : fieldParser.parseHeight(),
      streetAddress           : fieldParser.parseString("streetAddress"),
      city                    : fieldParser.parseString("city"),
      state                   : fieldParser.parseString("state"),
      postalCode              : fieldParser.parseString("postalCode"),
      customerId              : fieldParser.parseString("customerId"),
      documentId              : fieldParser.parseString("documentId"),
      country                 : fieldParser.parseCountry(),
      middleNameTruncation    : fieldParser.parseTruncationStatus("middleNameTruncation"),
      firstNameTruncation     : fieldParser.parseTruncationStatus("firstNameTruncation"),
      lastNameTruncation      : fieldParser.parseTruncationStatus("lastNameTruncation"),
      streetAddressSupplement : fieldParser.parseString("streetAddressSupplement"),
      hairColor               : fieldParser.parseHairColor(),
      placeOfBirth            : fieldParser.parseString("placeOfBirth"),
      auditInformation        : fieldParser.parseString("auditInformation"),
      inventoryControlNumber  : fieldParser.parseString("inventoryControlNumber"),
      lastNameAlias           : fieldParser.parseString("lastNameAlias"),
      firstNameAlias          : fieldParser.parseString("firstNameAlias"),
      suffixAlias             : fieldParser.parseString("suffixAlias"),
      suffix                  : fieldParser.parseNameSuffix(),
      version                 : parseVersion(),
      pdf417                  : data
    )
  }

  fileprivate func versionBasedFieldParsing(_ version: String?) -> FieldParser{
    let defaultParser = FieldParser(data: self.data)

    guard let v = version else { return defaultParser }

    switch v {
    case "01":
      return VersionOneFieldParser(data: self.data)
    case "02":
      return VersionTwoFieldParser(data: self.data)
    case "03":
      return VersionThreeFieldParser(data: self.data)
    case "04":
      return VersionFourFieldParser(data: self.data)
    case "05":
      return VersionFiveFieldParser(data: self.data)
    case "08":
      return VersionEightFieldParser(data: self.data)
    default:
      return defaultParser
    }
  }

  fileprivate func parseVersion() -> String?{
    return regex.firstMatch("\\d{6}(\\d{2})\\w+", data: data)
  }

}
