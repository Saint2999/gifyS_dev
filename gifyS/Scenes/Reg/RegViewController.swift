import SnapKit

protocol RegDisplayLogic: AnyObject {
    
    func displaySignUp(viewModel: Reg.SignUp.ViewModel)
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel)
}

class RegViewController: UIViewController, RegDisplayLogic, UITableViewDataSource, UITableViewDelegate {
    
    var interactor: RegBusinessLogic?
    var router: (NSObjectProtocol & RegRoutingLogic)?
    
    private var validated: Bool = true
    private weak var tableView: UITableView?
    private weak var imageCell: ImageTableViewCellDelegate?
    private weak var emailCell: TextFieldTableViewCellDelegate?
    private weak var usernameCell: TextFieldTableViewCellDelegate?
    private weak var passwordCell: TextFieldTableViewCellDelegate?
    private weak var passwordAgainCell: TextFieldTableViewCellDelegate?
    private weak var buttonCell: ButtonTableViewCellDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    private func setup() {
        let viewController = self
        let interactor = RegInteractor()
        let presenter = RegPresenter()
        let router = RegRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(tableView: &tableView)
    }
  
    func setupTableView(tableView: inout UITableView?) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .insetGrouped)
        tableView?.backgroundColor = UIColor.systemGray6
        tableView?.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        tableView?.separatorColor = UIColor.systemPurple
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView?.tableHeaderView = UIView(frame: frame)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "EmailTextFieldTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "UsernameTextFieldTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "PasswordTextFieldTableViewCell")
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonTableViewCell")
        
        self.view.addSubview(tableView ?? UITableView())
    }
    
    override func viewDidLayoutSubviews() {
        emailCell?.addTextFieldTarget(target: self, action: #selector(self.emailDidChange), event: .editingDidEnd)
        
        usernameCell?.addTextFieldTarget(target: self, action: #selector(self.usernameDidChange), event: .editingDidEnd)
        
        passwordCell?.addTextFieldTarget(target: self, action: #selector(self.passwordDidChange), event: .editingDidEnd)
        passwordAgainCell?.addTextFieldTarget(target: self, action: #selector(self.passwordDidChange), event: .editingDidEnd)
        
        buttonCell?.addButtonTarget(target: self, action: #selector(self.didTapButton), event: .touchUpInside)
    }
    
    func signUp() {
        let email = emailCell?.getText()
        let name = usernameCell?.getText()
        let password = passwordCell?.getText()
        let passwordAgain = passwordAgainCell?.getText()
        
        let request = Reg.SignUp.Request(email: email, name: name, password: password, passwordAgain: passwordAgain)
        interactor?.signUp(request: request)
    }
  
    func displaySignUp(viewModel: Reg.SignUp.ViewModel) {
        showSuccess(success: viewModel.success)
    }
      
    func showSuccess(success: Bool) {
        if success {
            imageCell?.changeColor(color: UIColor.systemGreen)
            router?.routeToGifCollection()
        } else {
            imageCell?.changeColor(color: UIColor.systemPink)
        }
    }
    
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel) {
        if validated == false {
            validated = true
        }
        if let emailError = viewModel.errorMessageEmail {
            emailCell?.setText(text: "")
            emailCell?.setAttributedPlaceholder(placeholder: emailError)
            validated = false
        }
        if let usernameError = viewModel.errorMessageUsername {
            usernameCell?.setText(text: "")
            usernameCell?.setAttributedPlaceholder(placeholder: usernameError)
            validated = false
        }
        if let passwordError = viewModel.errorMessagePassword {
            passwordCell?.setText(text: "")
            passwordCell?.setAttributedPlaceholder(placeholder: passwordError)
            passwordAgainCell?.setText(text: "")
            passwordAgainCell?.setAttributedPlaceholder(placeholder: passwordError)
            validated = false
        }
    }
    
    @objc func emailDidChange(textfield : UITextField) {
        let request = Reg.Validate.Request(email: textfield.text, username: nil, password: nil)
        interactor?.validate(request: request)
    }
        
    @objc func usernameDidChange(textfield : UITextField) {
        let request = Reg.Validate.Request(email: nil, username: textfield.text, password: nil)
        interactor?.validate(request: request)
    }
    
    @objc func passwordDidChange(textfield : UITextField) {
        let request = Reg.Validate.Request(email: nil, username: nil, password: textfield.text)
        interactor?.validate(request: request)
    }
    
    @objc func didTapButton() {
        if validated {
            signUp()
        } else {
            imageCell?.changeColor(color: UIColor.systemPink)
        }
    }
}

extension RegViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 1:
                return 4
            case 0, 2:
                return 1
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 50.0
            case 1:
                return 50.0
            case 2:
                return 75.0
            default:
                return 0.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell
                imageCell = ImageTableViewCell
            imageCell?.changeImage(imageName: "sparkles")
                return ImageTableViewCell ?? UITableViewCell()
            case 1:
                if indexPath.row < 2 {
                    if indexPath.row == 0 {
                        let EmailTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmailTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                        emailCell = EmailTextFieldTableViewCell
                        emailCell?.setAttributedPlaceholder(placeholder: NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple]))
                        
                        return EmailTextFieldTableViewCell ?? UITableViewCell()
                    } else {
                        let UsernameTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                        usernameCell = UsernameTextFieldTableViewCell
                        usernameCell?.setAttributedPlaceholder(placeholder: NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple]))
                        
                        return UsernameTextFieldTableViewCell ?? UITableViewCell()
                    }
                } else {
                    let PasswordTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                    
                    if indexPath.row == 2 {
                        passwordCell = PasswordTextFieldTableViewCell
                        passwordCell?.setAttributedPlaceholder(placeholder: NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple]))
                    } else {
                        passwordAgainCell = PasswordTextFieldTableViewCell
                        passwordAgainCell?.setAttributedPlaceholder(placeholder: NSAttributedString(string: "Password Again", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple]))
                    }
                    
                    return PasswordTextFieldTableViewCell ?? UITableViewCell()
                }
            case 2:
                let ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as? ButtonTableViewCell
                buttonCell = ButtonTableViewCell
                buttonCell?.setTitle(title: "Sign Up", state: .normal)
                
                return ButtonTableViewCell ?? UITableViewCell()

            default:
                return UITableViewCell()
        }
    }
}
