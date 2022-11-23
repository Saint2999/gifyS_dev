import UIKit

final class TableViewCellFactory {
    
    private init() {}
    
    class func configureCell(vc: UITableViewController, component: TableComponent) -> UITableViewCell {
        switch component.type {
        case .image:
            let ImageTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identificator) as? ImageTableViewCell
            ImageTableViewCell?.configure(component: component)
            return ImageTableViewCell ?? UITableViewCell()
        
        case .email:
            let EmailTextFieldTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identificator) as? TextFieldTableViewCell
            EmailTextFieldTableViewCell?.configure(component: component)
            EmailTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return EmailTextFieldTableViewCell ?? UITableViewCell()
        
        case .username:
            let UsernameTextFieldTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identificator) as? TextFieldTableViewCell
            UsernameTextFieldTableViewCell?.configure(component: component)
            UsernameTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return UsernameTextFieldTableViewCell ?? UITableViewCell()
        
        case .password:
            let PasswordTextFieldTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identificator) as? TextFieldTableViewCell
            PasswordTextFieldTableViewCell?.configure(component: component)
            PasswordTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return PasswordTextFieldTableViewCell ?? UITableViewCell()
        
        case .passwordAgain:
            let PasswordAgainTextFieldTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identificator) as? TextFieldTableViewCell
            PasswordAgainTextFieldTableViewCell?.configure(component: component)
            PasswordAgainTextFieldTableViewCell?.delegate = vc as? TextFieldTableViewCellDelegate
            return PasswordAgainTextFieldTableViewCell ?? UITableViewCell()
            
        case .button:
            let ButtonTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identificator) as? ButtonTableViewCell
            ButtonTableViewCell?.configure(component: component)
            ButtonTableViewCell?.delegate = vc as? ButtonTableViewCellDelegate
            return ButtonTableViewCell ?? UITableViewCell()
        
        case .label:
            let LabelTableViewCell = vc.tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identificator) as? LabelTableViewCell
            LabelTableViewCell?.configure(component: component)
            LabelTableViewCell?.delegate = vc as? LabelTableViewCellDelegate
            return LabelTableViewCell ?? UITableViewCell()
        }
    }
}
