import SnapKit
import Validator

protocol RegPresentationLogic {
    
    func presentSignUp(response: Reg.SignUp.Response)
    func presentValidationResult(response : Reg.Validate.Response)
}

class RegPresenter: RegPresentationLogic {
    
    weak var viewController: RegDisplayLogic?
  
    func presentSignUp(response: Reg.SignUp.Response) {
        let viewModel = Reg.SignUp.ViewModel(success: response.success)
        viewController?.displaySignUp(viewModel: viewModel)
    }
    
    func presentValidationResult(response: Reg.Validate.Response) {
        let emailError = getValidationErrorMessage(validationResult: response.validationResultEmail)
        let usernameError = getValidationErrorMessage(validationResult: response.validationResulUsername)
        let passwordError = getValidationErrorMessage(validationResult: response.validationResultPassword)

        let viewModel = Reg.Validate.ViewModel(errorMessageEmail: emailError, errorMessageUsername: usernameError,errorMessagePassword: passwordError)
            
        viewController?.displayValidationErrors(viewModel: viewModel)
    }
    
    func getValidationErrorMessage(validationResult : ValidationResult?) -> NSAttributedString? {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        
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
}
