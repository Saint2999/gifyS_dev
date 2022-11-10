import SnapKit

final class TableViewCellFactory {
    
    func configureCell(tableView: UITableView, signType: Helper.SignType, component: Helper.UIComponents) -> UITableViewCell {
        switch component {
        case .image:
            let ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
            ImageTableViewCell?.signType = signType
            return ImageTableViewCell ?? UITableViewCell()
        
        case .email:
            let EmailTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell
            EmailTextFieldTableViewCell?.component = Helper.UIComponents.email
            return EmailTextFieldTableViewCell ?? UITableViewCell()
        
        case .username:
            let UsernameTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell
            UsernameTextFieldTableViewCell?.component = Helper.UIComponents.username
            return UsernameTextFieldTableViewCell ?? UITableViewCell()
        
        case .password:
            let PasswordTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell
            PasswordTextFieldTableViewCell?.component = Helper.UIComponents.password
            return PasswordTextFieldTableViewCell ?? UITableViewCell()
        
        case .passwordAgain:
            let PasswordAgainTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell
            PasswordAgainTextFieldTableViewCell?.component = Helper.UIComponents.passwordAgain
            return PasswordAgainTextFieldTableViewCell ?? UITableViewCell()
            
        case .button:
            let ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as? ButtonTableViewCell
            ButtonTableViewCell?.signType = signType
            return ButtonTableViewCell ?? UITableViewCell()
        
        case .label:
            let LabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as? LabelTableViewCell
            LabelTableViewCell?.signType = signType
            return LabelTableViewCell ?? UITableViewCell()
        }
    }
}
