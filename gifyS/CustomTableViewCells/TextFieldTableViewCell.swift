import SnapKit

class TextFieldTableViewCell: UITableViewCell {
    
    lazy var mainTextField: SecureNonDeleteTextField = {
        let textField = SecureNonDeleteTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.tintColor = UIColor.systemPurple
        textField.textColor = UIColor.systemGreen
        return textField
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainTextField)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.systemGray6
        
        mainTextField.autocorrectionType = .no
        mainTextField.autocapitalizationType = .none
        mainTextField.clearsOnBeginEditing = false
        
        if reuseIdentifier == "UsernameTextFieldTableViewCell" || reuseIdentifier == "EmailTextFieldTableViewCell" {
            mainTextField.snp.makeConstraints {
                make in
                make.top.bottom.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
            }
        } else if reuseIdentifier == "PasswordTextFieldTableViewCell" {
            mainTextField.textContentType = .oneTimeCode
            mainTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
            mainTextField.isSecureTextEntry = true
            
            mainTextField.snp.makeConstraints {
                make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(self.snp.left).offset(20)
                make.right.equalTo(self.snp.right).offset(-60)
            }
            
            self.contentView.addSubview(mainImageView)
            
            mainImageView.contentMode = .scaleAspectFit
            mainImageView.image = UIImage(systemName: "eye.slash")
            mainImageView.tintColor = UIColor.systemGreen
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    override var inputAccessoryView: UIView? {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: mainTextField.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        doneButton.tintColor = UIColor.systemGreen
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        self.selectionStyle = .none
        return toolBar
    }

    @objc func didTapDone() {
        mainTextField.resignFirstResponder()
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
