import Validator

protocol AuthnPresentationLogic {
    
    func presentSignIn(response: Authn.SignIn.Response)
    func presentValidationResult(response: Authn.Validate.Response)
    func presentLoadDataSuccess(response: Authn.LoadData.Response)
}

class AuthnPresenter: AuthnPresentationLogic {
    
    weak var viewController: AuthnDisplayLogic?
  
    func presentSignIn(response: Authn.SignIn.Response) {
        let viewModel = Authn.SignIn.ViewModel(success: response.success)
        viewController?.displaySignIn(viewModel: viewModel)
    }
    
    func presentValidationResult(response: Authn.Validate.Response) {
        let emailError = getValidationErrorMessage(validationResult: response.validationResultEmail)
        let passwordError = getValidationErrorMessage(validationResult: response.validationResultPassword)

        let viewModel = Authn.Validate.ViewModel(errorMessageEmail: emailError, errorMessagePassword: passwordError)
        viewController?.displayValidationErrors(viewModel: viewModel)
    }
    
    func getValidationErrorMessage(validationResult: ValidationResult?) -> NSAttributedString? {
        let attributes = [NSAttributedString.Key.foregroundColor: Helper.errorColor]
        
        guard let validationResult = validationResult else {
            return nil
        }
        
        var attributed : NSAttributedString?
        
        switch validationResult {
            case .invalid(let errors):
                if(errors.count > 0) {
                    attributed = NSAttributedString(string: errors.first?.message ?? "NO error", attributes: attributes)
                }
            case .valid:
                attributed = nil
        }
        return attributed
    }

    func presentLoadDataSuccess(response: Authn.LoadData.Response) {
        let viewModel = Authn.LoadData.ViewModel(component: response.component, text: response.text, success: response.success)
        viewController?.displayLoadDataSuccess(viewModel: viewModel)
    }
}
