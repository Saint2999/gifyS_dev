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
    
    func signUp(request: Reg.SignUp.Request) {
        guard let email = email, let _ = username,
                let password = password, let passwordAgain = passwordAgain else { return }
        
        var success = false
        if password == passwordAgain {
            @UserDefault(key: email, defaultValue: "") var storedPassword: String
            if storedPassword == "" {
                storedPassword = password
                success = true
            }
        }
        
        let response = Reg.SignUp.Response(success: success)
        self.presenter?.presentSignUp(response: response)
        
//        worker.signUp(request: Reg.SignUp.Request(email: email, name: username, password: password, passwordAgain: passwordAgain)) {
//            success in
//            let response = Reg.SignUp.Response(success: success)
//            self.presenter?.presentSignUp(response: response)
//        }
    }
    
    func validate(request : Reg.Validate.Request) {
        var emailResult, usernameResult, passwordResult, passwordAgainResult: ValidationResult?
            
        if let value = email {
            emailResult =  worker.validateEmail(email: value)
        }
        if let value = username {
            usernameResult =  worker.validate(value: value)
        }
        if let value = password {
            passwordResult =  worker.validate(value: value)
        }
        if let value = passwordAgain {
            passwordAgainResult =  worker.validate(value: value)
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
