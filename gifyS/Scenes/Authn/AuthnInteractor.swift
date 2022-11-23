import Validator

protocol AuthnBusinessLogic {
    
    func signIn(request: Authn.SignIn.Request)
    func validate(request: Authn.Validate.Request)
    func loadData(request: Authn.LoadData.Request)
}

class AuthnInteractor: AuthnBusinessLogic {
    
    var presenter: AuthnPresentationLogic?
    var worker = AuthnWorker()
    
    private var email: String?
    private var password: String?
    
    private var validationResultEmail: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])
    private var validationResultPassword: ValidationResult = .invalid([ErrorCode(message: "Required", errorCode: ErrorCodes.required)])

    
    func signIn(request: Authn.SignIn.Request) {
        worker.signIn(request: Authn.SignIn.Request(email: email, password: password)) {
            success in
            let response = Authn.SignIn.Response(success: success)
            self.presenter?.presentSignIn(response: response)
        }
    }
    
    func validate(request : Authn.Validate.Request) {
        var emailResult, passwordResult: ValidationResult?
            
        if let value = email {
            validationResultEmail = worker.validateEmail(email: value)
            emailResult =  validationResultEmail
        }
        
        if let value = password {
            validationResultPassword = worker.validate(value: value)
            passwordResult =  validationResultPassword
        }
        
        let response = Authn.Validate.Response(validationResultEmail: emailResult,validationResultPassword: passwordResult)
        presenter?.presentValidationResult(response: response)
    }
    
    func loadData(request: Authn.LoadData.Request) {
        switch request.component {
        case .email:
            email = request.text
        
        case .password:
            password = request.text
        
        default:
            break
        }
        
        let response = Authn.LoadData.Response(success: true)
        presenter?.presentLoadDataSuccess(response: response)
    }
}
