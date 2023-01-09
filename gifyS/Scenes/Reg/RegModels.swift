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
        
        struct Request {}
                
        struct Response {
            
            var validationResultEmail: ValidationResult?
            var validationResulUsername: ValidationResult?
            var validationResultPassword: ValidationResult?
            var validationResultPasswordAgain: ValidationResult?
        }
                
        struct ViewModel {
            
            var errorMessageEmail: NSAttributedString?
            var errorMessageUsername: NSAttributedString?
            var errorMessagePassword: NSAttributedString?
            var errorMessagePasswordAgain: NSAttributedString?
        }
    }
    
    enum LoadData {
        
        struct Request {
            
            var component: TableComponentType
            var text: String?
        }
      
        struct Response {
            
            var component: TableComponentType
            var text: String?
            var success: Bool
        }
      
        struct ViewModel {
            
            var component: TableComponentType
            var text: String?
            var success: Bool
        }
    }
}
