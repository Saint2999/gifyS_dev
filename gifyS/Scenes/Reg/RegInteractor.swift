import SnapKit
import Validator

protocol RegBusinessLogic {
    
    func signUp(request: Reg.SignUp.Request)
    func validate(request: Reg.Validate.Request)
}

class RegInteractor: RegBusinessLogic {
    
    var presenter: RegPresentationLogic?
    var worker = RegWorker()
    
    private var email: String?
    private var username: String?
    private var password: String?
    
    private var validationResultEmail: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    private var validationResultUsername: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    private var validationResultPassword: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])

    
    func signUp(request: Reg.SignUp.Request) {
        worker.signUp(request: request) {
            success in
            let response = Reg.SignUp.Response(success: success)
            self.presenter?.presentSignUp(response: response)
        }
    }
    
    func validate(request : Reg.Validate.Request) {
        var emailResult, usernameResult, passwordResult: ValidationResult?
            
        if let value = request.email {
            validationResultEmail = worker.validateEmail(email: value)
            emailResult =  validationResultEmail
            email =  value
        }
            
        if let value = request.username {
            validationResultUsername = worker.validate(value: value)
            usernameResult =  validationResultUsername
            username =  value
        }
        
        if let value = request.password {
            validationResultPassword = worker.validate(value: value)
            passwordResult =  validationResultPassword
            password =  value
        }
        
        let response = Reg.Validate.Response(validationResultEmail: emailResult, validationResulUsername: usernameResult,validationResultPassword: passwordResult)
        self.presenter?.presentValidationResult(response: response)
    }
}
