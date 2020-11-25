private let arnDelimiter: Character = ":"
private let arnSections = 6
private let arnPrefix = "arn:"

private enum ARNSectionIndex: Int {
    case partition  = 1
    case service    = 2
    case region     = 3
    case accountID  = 4
    case resource   = 5
}

public enum ARNParseError: Error {
    case invalidPrefix
    case invalidFormat
}

public struct ARN {

    public var partition: String

    public var service: String

    public var region: String

    public var accountID: String

    public var resource: String

    public init(_ value: String) throws {
        guard value.hasPrefix(arnPrefix) else {
            throw ARNParseError.invalidPrefix
        }
        let splitedString = value.split(separator: arnDelimiter)
        guard splitedString.count == arnSections else {
            throw ARNParseError.invalidFormat
        }
        self.partition  = String(splitedString[ARNSectionIndex.partition.rawValue])
        self.service    = String(splitedString[ARNSectionIndex.service.rawValue])
        self.region     = String(splitedString[ARNSectionIndex.region.rawValue])
        self.accountID  = String(splitedString[ARNSectionIndex.accountID.rawValue])
        self.resource   = String(splitedString[ARNSectionIndex.resource.rawValue])
    }
}

extension ARN: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.partition == rhs.partition
            && lhs.service == rhs.service
            && lhs.region == rhs.region
            && lhs.accountID == rhs.accountID
            && lhs.resource == rhs.resource
    }
}
