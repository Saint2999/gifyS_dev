import SnapKit
import Validator

enum Authn {
    
    enum SignIn {
        
        struct Request: Encodable {
            
            var login: String?
            var password: String?
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
            var password: String?
        }
                
        struct Response {
            
            var validationResultEmail: ValidationResult?
            var validationResultPassword: ValidationResult?
        }
                
        struct ViewModel {
            
            var errorMessageEmail: NSAttributedString?
            var errorMessagePassword: NSAttributedString?
        }
    }
}
