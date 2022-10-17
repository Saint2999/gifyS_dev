import SnapKit
import Validator

protocol AuthnBusinessLogic
{
    func signIn(request: Authn.SignIn.Request)
    func validate(request: Authn.Validate.Request)
}

class AuthnInteractor: AuthnBusinessLogic
{
    var presenter: AuthnPresentationLogic?
    var worker = AuthnWorker()
    
    var email: String?
    var password: String?
    
    var validationResultEmail: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    var validationResultPassword: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])

    
    func signIn(request: Authn.SignIn.Request)
    {
        worker.signIn(login: request.login, password: request.password)
        {
            success in
            let response = Authn.SignIn.Response(success: success)
            self.presenter?.presentSignIn(response: response)
        }
    }
    
    func validate(request : Authn.Validate.Request)
    {
        var emailResult, passwordResult: ValidationResult?
            
        if let value = request.email
        {
            validationResultEmail = worker.validateEmail(email: value)
            emailResult =  validationResultEmail
            email =  value
        }
        
        if let value = request.password
        {
            validationResultPassword = worker.validate(value: value)
            passwordResult =  validationResultPassword
            password =  value
        }
        
        let response = Authn.Validate.Response(validationResultEmail: emailResult,validationResultPassword: passwordResult)
        self.presenter?.presentValidationResult(response: response)
    }
}
