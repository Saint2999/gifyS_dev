import SnapKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    
    func textDidChange(component: TableComponentType, text: String?)
}

final class TextFieldTableViewCell: UITableViewCell {
    
    static let identificator = "TextFieldTableViewCell"
    
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
        textField.rightView = mainButton
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        return textField
    }()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Helper.successColor
        button.setImage(Helper.eyeSlashImage, for: .normal)
        button.setImage(Helper.eyeImage, for: .selected)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private var component: TableComponent! {
        didSet {
            mainTextField.attributedPlaceholder = component.config.attributedPlaceholder
            mainTextField.text = component.config.title
            switch component.type {
            case .email, .username:
                mainTextField.textContentType = .none
                mainTextField.isSecureTextEntry = false
                mainTextField.rightViewMode = .never
                
            case .password, .passwordAgain:
                mainTextField.textContentType = .oneTimeCode
                mainTextField.isSecureTextEntry = true
                mainTextField.rightViewMode = .whileEditing
                
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
        setupCellView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCellView() {
        self.contentView.addSubview(mainTextField)
        self.selectionStyle = .none
        self.backgroundColor = Helper.backgroundColor
    }
    
    private func setupConstraints() {
        mainTextField.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func configure(component: TableComponent) {
        self.component = component
    }
    
    @objc func didTapButton() {
        mainButton.isSelected = !mainButton.isSelected
        mainTextField.isSecureTextEntry = !mainTextField.isSecureTextEntry
    }
   
    @objc func didTapDone() {
        mainTextField.resignFirstResponder()
    }

    @objc func textFieldDidChange() {
        delegate?.textDidChange(component: component.type, text: mainTextField.text)
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
