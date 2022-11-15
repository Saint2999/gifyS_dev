import UIKit

protocol AuthnDisplayLogic: AnyObject {
    
    func displaySignIn(viewModel: Authn.SignIn.ViewModel)
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel)
}

protocol AuthnVCImageDelegate: AnyObject {
    
    func changeImageColor(color: UIColor)
}

protocol AuthnVCTextFieldDelegate: AnyObject {
    
    func getText() -> String?
    func setText(text: String?)
    func setAttributedPlaceholder(placeholder: NSAttributedString?)
}

class AuthnViewController: UITableViewController, AuthnDisplayLogic {
    
    var interactor: AuthnBusinessLogic?
    var router: (NSObjectProtocol & AuthnRoutingLogic)?
    
    private weak var imageDelegate: AuthnVCImageDelegate?
    private weak var emailDelegate: AuthnVCTextFieldDelegate?
    private weak var passwordDelegate: AuthnVCTextFieldDelegate?
    
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
        let interactor = AuthnInteractor()
        let presenter = AuthnPresenter()
        let router = AuthnRouter()
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Helper.successColor
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        sections = [
            HelperAuthnReg.TableSection(type: .images, components: [.image]),
            HelperAuthnReg.TableSection(type: .textfields, components: [.email, .password]),
            HelperAuthnReg.TableSection(type: .buttons, components: [.button]),
            HelperAuthnReg.TableSection(type: .labels, components: [.label])
        ]
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableImageCellIdentifier)
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableTextfieldCellIdentifier)
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableButtonCellIdentifier)
        tableView?.register(LabelTableViewCell.self, forCellReuseIdentifier: HelperAuthnReg.tableLabelCellIdentifier)
    }
    
    func setupDelegates() {
        imageDelegate = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AuthnVCImageDelegate
        emailDelegate = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AuthnVCTextFieldDelegate
        passwordDelegate = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? AuthnVCTextFieldDelegate
    }
    
    func signIn() {
        let email = emailDelegate?.getText()
        let password = passwordDelegate?.getText()
        
        let request = Authn.SignIn.Request(login: email, password: password)
        interactor?.signIn(request: request)
    }
  
    func displaySignIn(viewModel: Authn.SignIn.ViewModel) {
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
    
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel) {
        if let emailError = viewModel.errorMessageEmail {
            emailDelegate?.setText(text: "")
            emailDelegate?.setAttributedPlaceholder(placeholder: emailError)
        }
        if let passwordError = viewModel.errorMessagePassword {
            passwordDelegate?.setText(text: "")
            passwordDelegate?.setAttributedPlaceholder(placeholder: passwordError)
        }
    }
}

extension AuthnViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].components.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .images:
            return 150.0
        
        case .textfields:
            return 50.0
        
        case .buttons:
            return 75.0
        
        case .labels:
            return 30.0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.configureCell(viewController: self, signType: HelperAuthnReg.SignType.signIn, component: sections[indexPath.section].components[indexPath.row])
        return cell
    }
}

extension AuthnViewController: TextFieldTableViewCellDelegate {
    
    func textDidChange(component: HelperAuthnReg.TableComponents, text: String?) {
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
