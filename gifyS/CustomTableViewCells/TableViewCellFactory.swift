import SnapKit

final class TableViewCellFactory {
    
    func configureCell(viewController: UITableViewController?, signType: Helper.SignType, component: Helper.UIComponents) -> UITableViewCell {
        weak var vc: UITableViewController?
        
        switch signType {
        case .signIn:
            vc = viewController as? AuthnViewController
        case .signUp:
            vc = viewController as? RegViewController
        }
        
        switch component {
        case .image:
            let ImageTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.imageCellIdentifier) as? ImageTableViewCell
            ImageTableViewCell?.signType = signType
            return ImageTableViewCell ?? UITableViewCell()
        
        case .email:
            let EmailTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.textfieldCellIdentifier) as? TextFieldTableViewCell
            EmailTextFieldTableViewCell?.component = Helper.UIComponents.email
            EmailTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return EmailTextFieldTableViewCell ?? UITableViewCell()
        
        case .username:
            let UsernameTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.textfieldCellIdentifier) as? TextFieldTableViewCell
            UsernameTextFieldTableViewCell?.component = Helper.UIComponents.username
            UsernameTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return UsernameTextFieldTableViewCell ?? UITableViewCell()
        
        case .password:
            let PasswordTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.textfieldCellIdentifier) as? TextFieldTableViewCell
            PasswordTextFieldTableViewCell?.component = Helper.UIComponents.password
            PasswordTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return PasswordTextFieldTableViewCell ?? UITableViewCell()
        
        case .passwordAgain:
            let PasswordAgainTextFieldTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.textfieldCellIdentifier) as? TextFieldTableViewCell
            PasswordAgainTextFieldTableViewCell?.component = Helper.UIComponents.passwordAgain
            PasswordAgainTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return PasswordAgainTextFieldTableViewCell ?? UITableViewCell()
            
        case .button:
            let ButtonTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.buttonCellIdentifier) as? ButtonTableViewCell
            ButtonTableViewCell?.signType = signType
            ButtonTableViewCell?.delegate = vc as? ButtonTableViewCellDelegate
            return ButtonTableViewCell ?? UITableViewCell()
        
        case .label:
            let LabelTableViewCell = vc?.tableView.dequeueReusableCell(withIdentifier: Helper.labelCellIdentifier) as? LabelTableViewCell
            LabelTableViewCell?.signType = signType
            LabelTableViewCell?.delegate = vc as? LabelTableViewCellDelegate
            return LabelTableViewCell ?? UITableViewCell()
        }
    }
}
