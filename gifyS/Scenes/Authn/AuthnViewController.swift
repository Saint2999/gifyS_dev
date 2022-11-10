import SnapKit
import ObjectiveC

protocol AuthnDisplayLogic: AnyObject {
    
    func displaySignIn(viewModel: Authn.SignIn.ViewModel)
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel)
}

class AuthnViewController: UIViewController, AuthnDisplayLogic {
    
    var interactor: AuthnBusinessLogic?
    var router: (NSObjectProtocol & AuthnRoutingLogic)?
    
    private weak var tableView: UITableView?
    private weak var imageCell: ImageTableViewCell?
    private weak var emailCell: TextFieldTableViewCell?
    private weak var passwordCell: TextFieldTableViewCell?
    private weak var buttonCell: ButtonTableViewCell?
    private weak var labelCell: LabelTableViewCell?
    
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
  
    func setup() {
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.systemGreen
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        sections = [
            Helper.Section(type: .image, components: [.image]),
            Helper.Section(type: .textfields, components: [.email, .password]),
            Helper.Section(type: .button, components: [.button]),
            Helper.Section(type: .label, components: [.label])
        ]
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonTableViewCell")
        tableView?.register(LabelTableViewCell.self, forCellReuseIdentifier: "LabelTableViewCell")
       
        self.view.addSubview(tableView ?? UITableView())
    }
    
    func signIn() {
        let email = emailCell?.text
        let password = passwordCell?.text
        let request = Authn.SignIn.Request(login: email, password: password)
        interactor?.signIn(request: request)
    }
  
    func displaySignIn(viewModel: Authn.SignIn.ViewModel) {
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
    
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel) {
        if let emailError = viewModel.errorMessageEmail {
            emailCell?.text = ""
            emailCell?.attributedPlaceholder = emailError
        }
        if let passwordError = viewModel.errorMessagePassword {
            passwordCell?.text = ""
            passwordCell?.attributedPlaceholder = passwordError
        }
    }
}

extension AuthnViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].components.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .image:
            return 150.0
        
        case .textfields:
            return 50.0
        
        case .button:
            return 75.0
        
        case .label:
            return 30.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.configureCell(tableView: tableView, signType: Helper.SignType.signIn, component: sections[indexPath.section].components[indexPath.row])
        
        switch sections[indexPath.section].components[indexPath.row] {
        case .image:
            imageCell = cell as? ImageTableViewCell
        
        case .email:
            emailCell = cell as? TextFieldTableViewCell
            emailCell?.delegate = self
        
        case .password:
            passwordCell = cell as? TextFieldTableViewCell
            passwordCell?.delegate = self
        
        case .button:
            buttonCell = cell as? ButtonTableViewCell
            buttonCell?.delegate = self
        
        case .label:
            labelCell = cell as? LabelTableViewCell
            labelCell?.delegate = self
        
        default:
            break
        }
        
        return cell
    }
}

extension AuthnViewController: TextFieldTableViewCellDelegate {
    
    func textDidChange(component: Helper.UIComponents, text: String?) {
        switch component {
        case .email:
            let request = Authn.Validate.Request(email: text, password: nil)
            interactor?.validate(request: request)
        
        case .password:
            let request = Authn.Validate.Request(email: nil, password: text)
            interactor?.validate(request: request)
        
        default:
            break
        }
    }
}

extension AuthnViewController: ButtonTableViewCellDelegate {
    
    func didTapButton() {
        signIn()
    }
}

extension AuthnViewController: LabelTableViewCellDelegate {
    
    func didTapLabel() {
        router?.routeToRegistration()
    }
}
