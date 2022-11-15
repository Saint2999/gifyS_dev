import UIKit

protocol RegDisplayLogic: AnyObject {
    
    func displaySignUp(viewModel: Reg.SignUp.ViewModel)
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel)
}

protocol RegVCImageDelegate: AnyObject {
    
    func changeImageColor(color: UIColor)
}

protocol RegVCTextFieldDelegate: AnyObject {
    
    func getText() -> String?
    func setText(text: String?)
    func setAttributedPlaceholder(placeholder: NSAttributedString?)
}

class RegViewController: UITableViewController, RegDisplayLogic {
    
    var interactor: RegBusinessLogic?
    var router: (NSObjectProtocol & RegRoutingLogic)?
    
    private weak var imageDelegate: RegVCImageDelegate?
    private weak var emailDelegate: RegVCTextFieldDelegate?
    private weak var usernameDelegate: RegVCTextFieldDelegate?
    private weak var passwordDelegate: RegVCTextFieldDelegate?
    private weak var passwordAgainDelegate: RegVCTextFieldDelegate?
    
    private var sections = [HelperAuthnReg.TableSection]()
    private var cellFactory = TableViewCellFactory()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        setupTableView()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupTableView()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    func setup() {
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
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .insetGrouped)
        tableView?.backgroundColor = Helper.backgroundColor
        tableView?.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        tableView?.separatorColor = Helper.primaryColor
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView?.tableHeaderView = UIView(frame: frame)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        sections = [
            HelperAuthnReg.TableSection(type: .images, components: [.image]),
            HelperAuthnReg.TableSection(type: .textfields, components: [.email, .username, .password, .passwordAgain]),
            HelperAuthnReg.TableSection(type: .buttons, components: [.button]),
        ]
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableImageCellIdentifier)
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableTextfieldCellIdentifier)
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableButtonCellIdentifier)
    }
    
    func setupDelegates() {
        imageDelegate = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegVCImageDelegate
        emailDelegate = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? RegVCTextFieldDelegate
        usernameDelegate = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? RegVCTextFieldDelegate
        passwordDelegate = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? RegVCTextFieldDelegate
        passwordAgainDelegate = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as? RegVCTextFieldDelegate
    }
    
    func signUp() {
        let email = emailDelegate?.getText()
        let name = usernameDelegate?.getText()
        let password = passwordDelegate?.getText()
        let passwordAgain = passwordAgainDelegate?.getText()
        
        let request = Reg.SignUp.Request(email: email, name: name, password: password, passwordAgain: passwordAgain)
        interactor?.signUp(request: request)
    }
  
    func displaySignUp(viewModel: Reg.SignUp.ViewModel) {
        showSuccess(success: viewModel.success)
    }
      
    func showSuccess(success: Bool) {
        if success {
            imageDelegate?.changeImageColor(color: Helper.successColor)
            router?.routeToGifCollection()
        } else {
            imageDelegate?.changeImageColor(color: Helper.errorColor)
        }
    }
    
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel) {
        if let emailError = viewModel.errorMessageEmail {
            emailDelegate?.setText(text: "")
            emailDelegate?.setAttributedPlaceholder(placeholder: emailError)
        }
        
        if let usernameError = viewModel.errorMessageUsername {
            usernameDelegate?.setText(text: "")
            usernameDelegate?.setAttributedPlaceholder(placeholder: usernameError)
        }
        
        if let passwordError = viewModel.errorMessagePassword {
            passwordDelegate?.setText(text: "")
            passwordDelegate?.setAttributedPlaceholder(placeholder: passwordError)
            passwordAgainDelegate?.setText(text: "")
            passwordAgainDelegate?.setAttributedPlaceholder(placeholder: passwordError)
        }
    }
}

extension RegViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].components.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .images:
            return 50.0
            
        case .textfields:
            return 50.0
        
        case .buttons:
            return 75.0
        
        default:
            return 0.0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.configureCell(viewController: self, signType: HelperAuthnReg.SignType.signUp, component: sections[indexPath.section].components[indexPath.row])
        return cell
    }
}

extension RegViewController: TextFieldTableViewCellDelegate {
    
    func textDidChange(component: HelperAuthnReg.TableComponents, text: String?) {
        switch component {
        case .email:
            let request = Reg.Validate.Request(email: text, username: nil, password: nil)
            interactor?.validate(request: request)
        
        case .username:
            let request = Reg.Validate.Request(email: nil, username: text, password: nil)
            interactor?.validate(request: request)
            
        case .password, .passwordAgain:
            let request = Reg.Validate.Request(email: nil, username: nil, password: text)
            interactor?.validate(request: request)
        
        default:
            break
        }
    }
}

extension RegViewController: ButtonTableViewCellDelegate {
    
    func didTapButton() {
        signUp()
    }
}
