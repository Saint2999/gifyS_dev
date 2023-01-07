import UIKit

protocol RegDisplayLogic: AnyObject {
    
    func displaySignUp(viewModel: Reg.SignUp.ViewModel)
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel)
    func displayLoadDataSuccess(viewModel: Reg.LoadData.ViewModel)
}

class RegViewController: UITableViewController {
    
    var interactor: RegBusinessLogic?
    var router: (NSObjectProtocol & RegRoutingLogic)?
    
    private var sections = [TableSection]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        setupTableView()
        setupBackButton()
        setupKeyboard()
        setupViewModel()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .insetGrouped)
        tableView?.backgroundColor = Helper.backgroundColor
        tableView?.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        tableView?.separatorColor = Helper.primaryColor
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView?.tableHeaderView = UIView(frame: frame)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identificator)
        tableView?.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identificator)
        tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identificator)
    }
    
    private func setupBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "BACK".localized, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Helper.successColor
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViewModel() {
        sections = [
            TableSection (
                type: .images,
                components: [
                    TableComponent (
                        type: .image,
                        config: TableCellConfig(image: Helper.signUpImage, color: Helper.primaryColor)
                    )
                ]
            ),
            TableSection (
                type: .textfields,
                components: [
                    TableComponent (
                        type: .email,
                        config: TableCellConfig(attributedPlaceholder: "EMAIL".localized.attributed(color: Helper.primaryColor))
                    ),
                    TableComponent (
                        type: .username,
                        config: TableCellConfig(attributedPlaceholder: "USERNAME".localized.attributed(color: Helper.primaryColor))
                    ),
                    TableComponent (
                        type: .password,
                        config: TableCellConfig(attributedPlaceholder: "PASSWORD".localized.attributed(color: Helper.primaryColor))
                    ),
                    TableComponent (
                        type: .passwordAgain,
                        config: TableCellConfig(attributedPlaceholder: "PASSWORD_AGAIN".localized.attributed(color: Helper.primaryColor))
                    )
                ]
            ),
            TableSection (
                type: .buttons,
                components: [
                    TableComponent (
                        type: .button,
                        config: TableCellConfig(title: "SIGN_UP_REG".localized)
                    )
                ]
            )
        ]
        tableView.reloadData()
    }
    
    func signUp() {
        let request = Reg.SignUp.Request()
        interactor?.signUp(request: request)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 105
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension RegViewController: RegDisplayLogic {

    func displaySignUp(viewModel: Reg.SignUp.ViewModel) {
        if viewModel.success {
            router?.routeToGifCollection()
        } else {
            let newConfig = TableCellConfig(image: Helper.signInImage, color: Helper.errorColor)
            setComponentConfig(sectionType: .images, componentType: .image, config: newConfig)
        }
    }
    
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel) {
        var newConfig: TableCellConfig
        
        if let emailError = viewModel.errorMessageEmail {
            newConfig = TableCellConfig(attributedPlaceholder: emailError)
        } else {
            newConfig = TableCellConfig(attributedPlaceholder: "EMAIL".localized.attributed(color: Helper.primaryColor))
        }
        setComponentConfig(sectionType: .textfields, componentType: .email, config: newConfig)
        
        if let usernameError = viewModel.errorMessageUsername {
            newConfig = TableCellConfig(attributedPlaceholder: usernameError)
        } else {
            newConfig = TableCellConfig(attributedPlaceholder: "USERNAME".localized.attributed(color: Helper.primaryColor))
        }
        setComponentConfig(sectionType: .textfields, componentType: .username, config: newConfig)
        
        if let passwordError = viewModel.errorMessagePassword {
            newConfig = TableCellConfig(attributedPlaceholder: passwordError)
        } else {
            newConfig = TableCellConfig(attributedPlaceholder: "PASSWORD".localized.attributed(color: Helper.primaryColor))
        }
        setComponentConfig(sectionType: .textfields, componentType: .password, config: newConfig)
        
        if let passwordAgainError = viewModel.errorMessagePasswordAgain {
            newConfig = TableCellConfig(attributedPlaceholder: passwordAgainError)
        } else {
            newConfig = TableCellConfig(attributedPlaceholder: "PASSWORD_AGAIN".localized.attributed(color: Helper.primaryColor))
        }
        setComponentConfig(sectionType: .textfields, componentType: .passwordAgain, config: newConfig)
        
        tableView.reloadData()
        
        if (viewModel.errorMessageEmail == nil && viewModel.errorMessageUsername == nil &&
            viewModel.errorMessagePassword == nil && viewModel.errorMessagePasswordAgain == nil) {
            signUp()
        }
    }
    
    private func setComponentConfig(sectionType: TableSectionType, componentType: TableComponentType, config: TableCellConfig) {
        if let section = sections.firstIndex(where: {$0.type == sectionType}),
           let component = sections[section].components.firstIndex(where: {$0.type == componentType}) {
            if let image = config.image {
                sections[section].components[component].config.image = image
            }
            
            if let title = config.title {
                sections[section].components[component].config.title = title
            }
            
            if let attributedPlaceholder = config.attributedPlaceholder {
                sections[section].components[component].config.attributedPlaceholder = attributedPlaceholder
            }
            
            if let color = config.color {
                sections[section].components[component].config.color = color
            }
        }
    }
    
    func displayLoadDataSuccess(viewModel: Reg.LoadData.ViewModel) {
        if viewModel.success {
            let newConfig = TableCellConfig(title: viewModel.text)
            setComponentConfig(sectionType: .textfields, componentType: viewModel.component, config: newConfig)
            
            tableView.reloadData()
            
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
        let cell = TableViewCellFactory.configureCell(vc: self, component: sections[indexPath.section].components[indexPath.row])
        return cell
    }
}

extension RegViewController: TextFieldTableViewCellDelegate {
    
    func textDidChange(component: TableComponentType, text: String?) {
        let request = Reg.LoadData.Request(component: component, text: text)
        interactor?.loadData(request: request)
    }
}

extension RegViewController: ButtonTableViewCellDelegate {
    
    func didTapButton() {
        let request = Reg.Validate.Request()
        interactor?.validate(request: request)
    }
}
