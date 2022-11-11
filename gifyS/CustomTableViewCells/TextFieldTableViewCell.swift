import SnapKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    
    func textDidChange(component: Helper.UIComponents, text: String?)
}

final class TextFieldTableViewCell: UITableViewCell {
    
    weak var delegate: TextFieldTableViewCellDelegate?
    
    private lazy var mainTextField: SecureNonDeleteTextField = {
        let textField = SecureNonDeleteTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.tintColor = Helper.primaryColor
        textField.textColor = Helper.successColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearsOnBeginEditing = false
        return textField
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var component: Helper.UIComponents = .email {
        didSet {
            switch component {
            case .email, .username:
                configureInsecureComponent(component: component)
            
            case .password, .passwordAgain:
                configureSecureComponent(component: component)
            
            default:
                break
            }
        }
    }
    
    override var inputAccessoryView: UIView? {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: mainTextField.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        doneButton.tintColor = Helper.successColor
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        self.selectionStyle = .none
        return toolBar
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainTextField)
        self.selectionStyle = .none
        self.backgroundColor = Helper.backgroundColor
        
        mainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureInsecureComponent(component: Helper.UIComponents) {
        if (component == .email) {
            mainTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: Helper.primaryColor])
        }
        else {
            mainTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: Helper.primaryColor])
        }
        
        mainTextField.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func configureSecureComponent(component: Helper.UIComponents) {
        mainTextField.textContentType = .oneTimeCode
        mainTextField.isSecureTextEntry = true
        if (component == .password) {
            mainTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: Helper.primaryColor])
        }
        else {
            mainTextField.attributedPlaceholder = NSAttributedString(string: "Password Again", attributes: [NSAttributedString.Key.foregroundColor: Helper.primaryColor])
        }
        
        mainTextField.snp.makeConstraints {
            make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-60)
        }
        
        self.contentView.addSubview(mainImageView)
        
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.image = UIImage(systemName: "eye.slash")
        mainImageView.tintColor = Helper.successColor
        mainImageView.isUserInteractionEnabled = true
        
        mainImageView.snp.makeConstraints {
            make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(mainTextField.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped() {
        if mainTextField.isSecureTextEntry == true {
            mainTextField.isSecureTextEntry = false
            mainImageView.image = UIImage(systemName: "eye")
        } else if mainTextField.isSecureTextEntry == false {
            mainTextField.isSecureTextEntry = true
            mainImageView.image = UIImage(systemName: "eye.slash")
        }
    }

    @objc func didTapDone() {
        mainTextField.resignFirstResponder()
    }

    @objc func textFieldDidChange() {
        delegate?.textDidChange(component: component, text: mainTextField.text)
    }
}

class SecureNonDeleteTextField: UITextField {
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
}

extension TextFieldTableViewCell: AuthnVCTextFieldDelegate, RegVCTextFieldDelegate {
    
    func getText() -> String? {
        return mainTextField.text
    }
    
    func setText(text: String?) {
        mainTextField.text = text
    }
    
    func setAttributedPlaceholder(placeholder: NSAttributedString?) {
        mainTextField.attributedPlaceholder = placeholder
    }
}
