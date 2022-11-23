import Validator

protocol RegBusinessLogic {
    
    func signUp(request: Reg.SignUp.Request)
    func validate(request: Reg.Validate.Request)
    func loadData(request: Reg.LoadData.Request)
}

class RegInteractor: RegBusinessLogic {
    
    var presenter: RegPresentationLogic?
    var worker = RegWorker()
    
    private var email: String?
    private var username: String?
    private var password: String?
    private var passwordAgain: String?
    
    private var validationResultEmail: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    private var validationResultUsername: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    private var validationResultPassword: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    private var validationResultPasswordAgain: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])

    func signUp(request: Reg.SignUp.Request) {
        worker.signUp(request: Reg.SignUp.Request(email: email, name: username, password: password, passwordAgain: passwordAgain)) {
            success in
            let response = Reg.SignUp.Response(success: success)
            self.presenter?.presentSignUp(response: response)
        }
    }
    
    func validate(request : Reg.Validate.Request) {
        var emailResult, usernameResult, passwordResult, passwordAgainResult: ValidationResult?
            
        if let value = email {
            validationResultEmail = worker.validateEmail(email: value)
            emailResult =  validationResultEmail
        }
    
        if let value = username {
            validationResultUsername = worker.validate(value: value)
            usernameResult =  validationResultUsername
        }
        
        if let value = password {
            validationResultPassword = worker.validate(value: value)
            passwordResult =  validationResultPassword
        }
        
        if let value = passwordAgain {
            validationResultPasswordAgain = worker.validate(value: value)
            passwordAgainResult =  validationResultPassword
        }

        let response = Reg.Validate.Response(validationResultEmail: emailResult, validationResulUsername: usernameResult, validationResultPassword: passwordResult, validationResultPasswordAgain: passwordAgainResult)
        self.presenter?.presentValidationResult(response: response)
    }
    
    func loadData(request: Reg.LoadData.Request) {
        switch request.component {
        case .email:
            email = request.text
        
        case .username:
            username = request.text
        
        case .password:
            password = request.text
        
        case .passwordAgain:
            passwordAgain = request.text
            
        default:
            break
        }
        
        let response = Reg.LoadData.Response(success: true)
        presenter?.presentLoadDataSuccess(response: response)
    }
}
