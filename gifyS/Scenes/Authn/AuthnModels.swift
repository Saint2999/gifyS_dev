import Validator

enum Authn {
    
    enum SignIn {
        
        struct Request: Codable {
            
            var email: String?
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
        
        struct Request {}
                
        struct Response {
            
            var validationResultEmail: ValidationResult?
            var validationResultPassword: ValidationResult?
        }
                
        struct ViewModel {
            
            var errorMessageEmail: NSAttributedString?
            var errorMessagePassword: NSAttributedString?
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
