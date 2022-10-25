import SnapKit
import Validator
import Alamofire

class AuthnWorker {
    
    let login_url = "https://mainsoup.backendless.app/api/users/login"

    func signIn(login: String?, password: String?, completionHandler: @escaping (Bool) -> Void) {
        let login = Authn.SignIn.Request(login: login!, password: password!)
                    
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
                    
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response {
            response in
            debugPrint(response)
            switch response.result {
                case .success:
                    if response.response!.statusCode >= 400 {
                        completionHandler(false)
                    } else {
                        completionHandler(true)
                    }
                case .failure:
                    completionHandler(false)
            }
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
