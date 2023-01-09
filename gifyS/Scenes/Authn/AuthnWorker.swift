import Validator
import Alamofire

class AuthnWorker {
    
    func signIn(request: Authn.SignIn.Request, completion: @escaping (Bool) -> Void) {
        NetworkManager.makeWebRequest(url: NetworkHelper.loginURL, method: .post, parameters: request, responseType: Bool.self) {
            response, error in
            if error != nil {
                debugPrint(error as Any)
            }
            completion(response!)
        }
    }
    
    func validateEmail(email : String) -> ValidationResult {
        var result =  email.validate(rule: ValidatorRules.minLengthRule)
        if (result != .valid) {
            return result
        }
            
        result =  email.validate(rule: ValidatorRules.maxLengthRule)
        if (result != .valid) {
            return result
        }
            
        result = email.validate(rule: ValidatorRules.emailRule)
        if (result != .valid) {
            return result
        }
        
        return .valid
    }
    
    func validate(value : String) -> ValidationResult {
        var result = value.validate(rule: ValidatorRules.minLengthRule)
        if (result != .valid) {
            return result
        }
        
        result = value.validate(rule: ValidatorRules.maxLengthRule)
        if (result != .valid) {
            return result
        }
        return .valid
    }
}
