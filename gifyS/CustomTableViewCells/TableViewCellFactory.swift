import UIKit

final class TableViewCellFactory {
    
    func configureCell(viewController: UITableViewController?, signType: HelperAuthnReg.SignType, component: HelperAuthnReg.TableComponents) -> UITableViewCell {
        weak var vc: UITableViewController?
        
        switch signType {
        case .signIn:
            vc = viewController as? AuthnViewController
        case .signUp:
            vc = viewController as? RegViewController
        }
        
        switch component {
        case .image:
            let ImageTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableImageCellIdentifier) as? ImageTableViewCell
            ImageTableViewCell?.signType = signType
            return ImageTableViewCell ?? UITableViewCell()
        
        case .email:
            let EmailTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableTextfieldCellIdentifier) as? TextFieldTableViewCell
            EmailTextFieldTableViewCell?.component = HelperAuthnReg.TableComponents.email
            EmailTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return EmailTextFieldTableViewCell ?? UITableViewCell()
        
        case .username:
            let UsernameTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableTextfieldCellIdentifier) as? TextFieldTableViewCell
            UsernameTextFieldTableViewCell?.component = HelperAuthnReg.TableComponents.username
            UsernameTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return UsernameTextFieldTableViewCell ?? UITableViewCell()
        
        case .password:
            let PasswordTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableTextfieldCellIdentifier) as? TextFieldTableViewCell
            PasswordTextFieldTableViewCell?.component = HelperAuthnReg.TableComponents.password
            PasswordTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return PasswordTextFieldTableViewCell ?? UITableViewCell()
        
        case .passwordAgain:
            let PasswordAgainTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableTextfieldCellIdentifier) as? TextFieldTableViewCell
            PasswordAgainTextFieldTableViewCell?.component = HelperAuthnReg.TableComponents.passwordAgain
            PasswordAgainTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return PasswordAgainTextFieldTableViewCell ?? UITableViewCell()
            
        case .button:
            let ButtonTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableButtonCellIdentifier) as? ButtonTableViewCell
            ButtonTableViewCell?.signType = signType
            ButtonTableViewCell?.delegate = vc as? ButtonTableViewCellDelegate
            return ButtonTableViewCell ?? UITableViewCell()
        
        case .label:
            let LabelTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: HelperAuthnReg.tableLabelCellIdentifier) as? LabelTableViewCell
            LabelTableViewCell?.signType = signType
            LabelTableViewCell?.delegate = vc as? LabelTableViewCellDelegate
            return LabelTableViewCell ?? UITableViewCell()
        }
    }
}
