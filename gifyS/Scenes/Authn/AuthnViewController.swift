import SnapKit

protocol AuthnDisplayLogic: AnyObject
{
    func displaySignIn(viewModel: Authn.SignIn.ViewModel)
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel)
}

class AuthnViewController: UIViewController, AuthnDisplayLogic, UITableViewDataSource, UITableViewDelegate
{
    var interactor: AuthnBusinessLogic?
    var router: (NSObjectProtocol & AuthnRoutingLogic)?
    
    var validated: Bool = true
    weak var tableView: UITableView?
    weak var imageCell: ImageTableViewCell?
    weak var emailCell: TextFieldTableViewCell?
    weak var passwordCell: TextFieldTableViewCell?
    weak var buttonCell: ButtonTableViewCell?
    weak var labelCell: LabelTableViewCell?

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
  
    func setup()
    {
        let viewController = self
        let interactor = AuthnInteractor()
        let presenter = AuthnPresenter()
        let router = AuthnRouter()
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.systemGreen
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "EmailTextFieldTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "PasswordTextFieldTableViewCell")
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonTableViewCell")
        tableView?.register(LabelTableViewCell.self, forCellReuseIdentifier: "LabelTableViewCell")
       
        self.view.addSubview(tableView ?? UITableView())
    }
    
    override func viewDidLayoutSubviews()
    {
        connectUIElements(tableView: &tableView)
        
        emailCell?.mainTextField.addTarget(self, action: #selector(self.emailDidChange), for: .editingDidEnd)
        passwordCell?.mainTextField.addTarget(self, action: #selector(self.passwordDidChange), for: .editingDidEnd)
        
        buttonCell?.mainButton.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapSignUpLabel))
        labelCell?.mainLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func connectUIElements(tableView: inout UITableView?)
    {
        imageCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell
        emailCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextFieldTableViewCell
        passwordCell = tableView?.cellForRow(at: IndexPath(row: 1, section: 1)) as? TextFieldTableViewCell
        buttonCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 2)) as? ButtonTableViewCell
        labelCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 3)) as? LabelTableViewCell
    }
    
    func signIn()
    {
        let email = emailCell?.mainTextField.text
        let password = passwordCell?.mainTextField.text
        let request = Authn.SignIn.Request(login: email, password: password)
        interactor?.signIn(request: request)
    }
  
    func displaySignIn(viewModel: Authn.SignIn.ViewModel)
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
    
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel)
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
        if let passwordError = viewModel.errorMessagePassword
        {
            passwordCell?.mainTextField.text = ""
            passwordCell?.mainTextField.attributedPlaceholder = passwordError
            validated = false
        }
    }
    
    @objc func emailDidChange(textfield : UITextField)
    {
        let request = Authn.Validate.Request(email: textfield.text, password: nil)
        interactor?.validate(request: request)
    }
    
    @objc func passwordDidChange(textfield : UITextField)
    {
        let request = Authn.Validate.Request(email: nil, password: textfield.text)
        interactor?.validate(request: request)
    }
    
    @objc func didTapButton()
    {
        if validated
        {
            signIn()
        }
        else
        {
            imageCell?.mainImageView.tintColor = UIColor.systemPink
        }
    }
    
    @objc func didTapSignUpLabel()
    {
        router?.routeToRegistration()
    }
}

extension AuthnViewController
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
            case 0, 2, 3:
                return 1
            case 1:
                return 2
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section
        {
            case 0:
                return 150.0
            case 1:
                return 50.0
            case 2:
                return 75.0
            case 3:
                return 30.0
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
                ImageTableViewCell?.mainImageView.image = UIImage(systemName: "theatermasks.fill")
                return ImageTableViewCell ?? UITableViewCell()
                
            case 1:
                if indexPath.row == 0
                {
                    let EmailTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmailTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
        
                    EmailTextFieldTableViewCell?.mainTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
                    
                    return EmailTextFieldTableViewCell ?? UITableViewCell()
                }
                else if indexPath.row == 1
                {
                    let PasswordTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                    
                    PasswordTextFieldTableViewCell?.mainTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPurple])
                    
                    return PasswordTextFieldTableViewCell ?? UITableViewCell()
                }
                
            case 2:
                let ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as? ButtonTableViewCell
                
                ButtonTableViewCell?.mainButton.setTitle("Sign In", for: .normal)
                    
                return ButtonTableViewCell ?? UITableViewCell()
                
            case 3:
                let LabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell
                
                LabelTableViewCell?.mainLabel.text = "Sign Up"
                
                return LabelTableViewCell ?? UITableViewCell()
                
            default:
                return UITableViewCell()
        }
        return UITableViewCell()
    }
}
