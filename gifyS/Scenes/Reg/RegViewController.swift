import SnapKit

protocol RegDisplayLogic: AnyObject
{
    func displaySignUp(viewModel: Reg.SignUp.ViewModel)
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel)
}

class RegViewController: UIViewController, RegDisplayLogic, UITableViewDataSource, UITableViewDelegate
{
    var interactor: RegBusinessLogic?
    var router: (NSObjectProtocol & RegRoutingLogic)?
    
    var validated: Bool = true
    weak var tableView: UITableView?
    weak var imageCell: ImageTableViewCell?
    weak var emailCell: TextFieldTableViewCell?
    weak var usernameCell: TextFieldTableViewCell?
    weak var passwordCell: TextFieldTableViewCell?
    weak var passwordAgainCell: TextFieldTableViewCell?
    weak var buttonCell: ButtonTableViewCell?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
  
    private func setup()
    {
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
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTableView(tableView: &tableView)
    }
  
    func setupTableView(tableView: inout UITableView?)
    {
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
    override func viewDidLayoutSubviews()
    {
        
        connectUIElements(tableView: &tableView)
        
        emailCell?.mainTextField.addTarget(self, action: #selector(self.emailDidChange), for: .editingDidEnd)
        usernameCell?.mainTextField.addTarget(self, action: #selector(self.usernameDidChange), for: .editingDidEnd)
        passwordCell?.mainTextField.addTarget(self, action: #selector(self.passwordDidChange), for: .editingDidEnd)
        passwordAgainCell?.mainTextField.addTarget(self, action: #selector(self.passwordDidChange), for: .editingDidEnd)
        
        buttonCell?.mainButton.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
    }
    
    func connectUIElements(tableView: inout UITableView?)
    {
        imageCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell
        emailCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextFieldTableViewCell
        usernameCell = tableView?.cellForRow(at: IndexPath(row: 1, section: 1)) as? TextFieldTableViewCell
        passwordCell = tableView?.cellForRow(at: IndexPath(row: 2, section: 1)) as? TextFieldTableViewCell
        passwordAgainCell = tableView?.cellForRow(at: IndexPath(row: 3, section: 1)) as? TextFieldTableViewCell
        buttonCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 2)) as? ButtonTableViewCell
    }
    
    func signUp()
    {
        let email = emailCell?.mainTextField.text
        let name = usernameCell?.mainTextField.text
        let password = passwordCell?.mainTextField.text
        let passwordAgain = passwordAgainCell?.mainTextField.text
        
        let request = Reg.SignUp.Request(email: email, name: name, password: password, passwordAgain: passwordAgain)
        interactor?.signUp(request: request)
    }
  
    func displaySignUp(viewModel: Reg.SignUp.ViewModel)
    {
        showSuccess(success: viewModel.success)
    }
      
    func showSuccess(success: Bool)
    {
        if success
        {
            imageCell?.mainImageView.tintColor = UIColor.systemGreen
            router?.routeToGifCollection()
        }
        else
        {
            imageCell?.mainImageView.tintColor = UIColor.systemPink
        }
    }
    
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel)
    {
        if validated == false
        {
            validated = true
        }
        if let emailError = viewModel.errorMessageEmail
        {
            emailCell?.mainTextField.text = ""
            emailCell?.mainTextField.attributedPlaceholder = emailError
            validated = false
        }
        if let usernameError = viewModel.errorMessageUsername
        {
            usernameCell?.mainTextField.text = ""
            usernameCell?.mainTextField.attributedPlaceholder = usernameError
            validated = false
        }
        if let passwordError = viewModel.errorMessagePassword
        {
            passwordCell?.mainTextField.text = ""
            passwordCell?.mainTextField.attributedPlaceholder = passwordError
            passwordAgainCell?.mainTextField.text = ""
            passwordAgainCell?.mainTextField.attributedPlaceholder = passwordError
            validated = false
        }
        
    }
    
    @objc func emailDidChange(textfield : UITextField)
    {
        let request = Reg.Validate.Request(email: textfield.text, username: nil, password: nil)
        interactor?.validate(request: request)
    }
        
    @objc func usernameDidChange(textfield : UITextField)
    {
        let request = Reg.Validate.Request(email: nil, username: textfield.text, password: nil)
        interactor?.validate(request: request)
    }
    
    @objc func passwordDidChange(textfield : UITextField)
    {
        let request = Reg.Validate.Request(email: nil, username: nil, password: textfield.text)
        interactor?.validate(request: request)
    }
    
    @objc func didTapButton()
    {
        if validated
        {
            signUp()
        }
        else
        {
            imageCell?.mainImageView.tintColor = UIColor.systemPink
        }
    }
}

extension RegViewController
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
            case 1:
                return 4
            case 0, 2:
                return 1
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section
        {
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
            case 0:
                let ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell
                ImageTableViewCell?.mainImageView.image = UIImage(systemName: "sparkles")
                return ImageTableViewCell ?? UITableViewCell()
            
            case 1:
                if indexPath.row < 2
                {
                    if indexPath.row == 0
                    {
                        let EmailTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmailTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                        EmailTextFieldTableViewCell?.mainTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
                        return EmailTextFieldTableViewCell ?? UITableViewCell()
                    }
                    else
                    {
                        let UsernameTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                        UsernameTextFieldTableViewCell?.mainTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
                        return UsernameTextFieldTableViewCell ?? UITableViewCell()
                    }
                }
                else
                {
                    let PasswordTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                    
                    if indexPath.row == 2
                    {
                        PasswordTextFieldTableViewCell?.mainTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
                    }
                    else
                    {
                        PasswordTextFieldTableViewCell?.mainTextField.attributedPlaceholder = NSAttributedString(string: "Password Again", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
                    }
                    
                    return PasswordTextFieldTableViewCell ?? UITableViewCell()
                }
            
            case 2:
                let ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as? ButtonTableViewCell
                
                ButtonTableViewCell?.mainButton.setTitle("Sign Up", for: .normal)
                
                return ButtonTableViewCell ?? UITableViewCell()

            default:
                return UITableViewCell()
        }
    }
}
