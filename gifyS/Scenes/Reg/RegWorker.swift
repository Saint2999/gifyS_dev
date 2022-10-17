import SnapKit
import Validator
import Alamofire

class RegWorker
{
    let register_url = "https://mainsoup.backendless.app/api/users/register"
    
    func signUp(email: String?, name: String?, password: String?, passwordAgain: String?, completionHandler: @escaping (Bool) -> Void)
    {
        if password == passwordAgain
        {
            let register = Reg.SignUp.Request(email: email!, name: name!, password: password!, passwordAgain: nil)
            
            let headers: HTTPHeaders =
            [
                .contentType("application/json")
            ]
            
            AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response
            {
                response in
                debugPrint(response)
                switch response.result
                {
                    case .success:
                        if response.response!.statusCode >= 400
                        {
                            completionHandler(false)
                        }
                        else
                        {
                            completionHandler(true)
                        }
                    case .failure:
                        completionHandler(false)
                }
            }
        }
        else
        {
            completionHandler(false)
        }
    }
    
    func validateEmail(email : String) -> ValidationResult
    {
        var result =  email.validate(rule: ValidatorRules.minLengthRule)
        if (result != .valid)
        {
            return result
        }
            
        result =  email.validate(rule: ValidatorRules.maxLengthRule)
        if (result != .valid)
        {
            return result
        }
            
        result = email.validate(rule: ValidatorRules.emailRule)
        if (result != .valid)
        {
            return result
        }
        
        return .valid
    }
        
    func validate(value : String) -> ValidationResult
    {
        var result = value.validate(rule: ValidatorRules.minLengthRule)
        if (result != .valid)
        {
            return result
        }
        
        result = value.validate(rule: ValidatorRules.maxLengthRule)
        if (result != .valid)
        {
            return result
        }
        return .valid
    }
}
