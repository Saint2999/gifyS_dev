import Validator
import Alamofire

class RegWorker {
    
    func signUp(request: Reg.SignUp.Request, completion: @escaping (Bool) -> Void) {
        if request.password == request.passwordAgain {
            NetworkManager.makeWebRequest(url: Helper.registerURL, method: .post, parameters: request, responseType: Bool.self) {
                response, error in
                if error != nil {
                    debugPrint(error as Any)
                }
                completion(response!)
            }
        } else {
            completion(false)
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
