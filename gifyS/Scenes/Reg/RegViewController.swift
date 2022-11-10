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
    private weak var imageCell: ImageTableViewCell?
    private weak var emailCell: TextFieldTableViewCell?
    private weak var usernameCell: TextFieldTableViewCell?
    private weak var passwordCell: TextFieldTableViewCell?
    private weak var passwordAgainCell: TextFieldTableViewCell?
    private weak var buttonCell: ButtonTableViewCell?
    
    private var sections = [Helper.Section]()
    private var cellFactory = TableViewCellFactory()
    
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
        
        sections = [
            Helper.Section(type: .image, components: [.image]),
            Helper.Section(type: .textfields, components: [.email, .username, .password, .passwordAgain]),
            Helper.Section(type: .button, components: [.button]),
        ]
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonTableViewCell")
        
        self.view.addSubview(tableView ?? UITableView())
    }
    
    func signUp() {
        let email = emailCell?.text
        let name = usernameCell?.text
        let password = passwordCell?.text
        let passwordAgain = passwordAgainCell?.text
        
        let request = Reg.SignUp.Request(email: email, name: name, password: password, passwordAgain: passwordAgain)
        interactor?.signUp(request: request)
    }
  
    func displaySignUp(viewModel: Reg.SignUp.ViewModel) {
        showSuccess(success: viewModel.success)
    }
      
    func showSuccess(success: Bool) {
        if success {
            imageCell?.color = Helper.successColor
            router?.routeToGifCollection()
        } else {
            imageCell?.color = Helper.errorColor
        }
    }
    
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel) {
        if validated == false {
            validated = true
        }
        if let emailError = viewModel.errorMessageEmail {
            emailCell?.text = ""
            emailCell?.attributedPlaceholder = emailError
            validated = false
        }
        if let usernameError = viewModel.errorMessageUsername {
            usernameCell?.text = ""
            usernameCell?.attributedPlaceholder = usernameError
            validated = false
        }
        if let passwordError = viewModel.errorMessagePassword {
            passwordCell?.text = ""
            passwordCell?.attributedPlaceholder = passwordError
            passwordAgainCell?.text = ""
            passwordAgainCell?.attributedPlaceholder = passwordError
            validated = false
        }
    }
}

extension RegViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].components.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .image:
            return 50.0
            
        case .textfields:
            return 50.0
        
        case .button:
            return 75.0
        
        default:
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.configureCell(tableView: tableView, signType: Helper.SignType.signUp, component: sections[indexPath.section].components[indexPath.row])
        
        switch sections[indexPath.section].components[indexPath.row] {
        case .image:
            imageCell = cell as? ImageTableViewCell
        
        case .email:
            emailCell = cell as? TextFieldTableViewCell
        
        case .username:
            usernameCell = cell as? TextFieldTableViewCell
        
        case .password:
            passwordCell = cell as? TextFieldTableViewCell
        
        case .passwordAgain:
            passwordAgainCell = cell as? TextFieldTableViewCell
        
        case .button:
            buttonCell = cell as? ButtonTableViewCell
            
        default:
            break
        }
        
        return cell
    }
}

extension RegViewController: TextFieldTableViewCellDelegate {
    
    func textDidChange(component: Helper.UIComponents, text: String?) {
        switch component {
        case .email:
            let request = Reg.Validate.Request(email: text, username: nil, password: nil)
            interactor?.validate(request: request)
        
        case .username:
            let request = Reg.Validate.Request(email: nil, username: text, password: nil)
            interactor?.validate(request: request)
            
        case .password:
            let request = Reg.Validate.Request(email: nil, username: nil, password: text)
            interactor?.validate(request: request)
        
        default:
            break
        }
    }
}

extension RegViewController: ButtonTableViewCellDelegate {
    
    func didTapButton() {
        if validated {
            signUp()
        } else {
            imageCell?.color = Helper.errorColor
        }
    }
}
