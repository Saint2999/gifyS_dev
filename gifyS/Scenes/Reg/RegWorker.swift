import SnapKit
import Validator
import Alamofire

class RegWorker {
    
    func signUp(request: Reg.SignUp.Request, completionHandler: @escaping (Bool) -> Void) {
        if request.password == request.passwordAgain {
            let register = Reg.SignUp.Request(email: request.email!, name: request.name!, password: request.password!, passwordAgain: nil)
            
            let headers: HTTPHeaders = [
                .contentType("application/json")
            ]
            
            AF.request(Helper.registerURL, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response {
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
        } else {
            completionHandler(false)
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
