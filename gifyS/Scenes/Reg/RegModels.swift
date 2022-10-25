import SnapKit
import Validator

enum Reg {
    
    enum SignUp {
        
        struct Request: Encodable {
            var email: String?
            var name: String?
            var password: String?
            var passwordAgain: String?
        }
      
        struct Response {
            var success: Bool
        }
      
        struct ViewModel {
            var success: Bool
        }
    }
    
    enum Validate {
        
        struct Request {
            var email: String?
            var username: String?
            var password: String?
        }
                
        struct Response {
            var validationResultEmail: ValidationResult?
            var validationResulUsername: ValidationResult?
            var validationResultPassword: ValidationResult?
        }
                
        struct ViewModel {
            var errorMessageEmail: NSAttributedString?
            var errorMessageUsername: NSAttributedString?
            var errorMessagePassword: NSAttributedString?
        }
    }
}
