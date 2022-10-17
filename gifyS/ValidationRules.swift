import Validator

enum ErrorCodes: Error
{
    case invalidEmail
    case required
    case minLength
    case maxLength
}

struct ErrorCode: ValidationError
{
    var message: String
    var errorCode : ErrorCodes
}

class ValidatorRules: NSObject
{
    let errorDomain = "gifyS"
    static let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ErrorCode(message: "Invalid email", errorCode: ErrorCodes.invalidEmail))
    static let minLengthRule = ValidationRuleLength(min: 6, error: ErrorCode(message: "Min length = 6", errorCode: ErrorCodes.minLength))
    static let maxLengthRule = ValidationRuleLength(max: 30, error: ErrorCode(message: "Max length = 30", errorCode: ErrorCodes.maxLength))
}
