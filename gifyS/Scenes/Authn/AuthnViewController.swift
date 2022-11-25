import UIKit

protocol AuthnDisplayLogic: AnyObject {
    
    func displaySignIn(viewModel: Authn.SignIn.ViewModel)
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel)
    func displayLoadDataSuccess(viewModel : Authn.LoadData.ViewModel)
}

class AuthnViewController: UITableViewController {
    
    var interactor: AuthnBusinessLogic?
    var router: (NSObjectProtocol & AuthnRoutingLogic)?
    
    private var sections = [TableSection]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        setupTableView()
        setupBackButton()
        setupViewModel()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
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
        tableView?.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identificator)
    }
    
    private func setupBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "BACK".localized, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Helper.successColor
    }
    
    private func setupViewModel() {
        sections = [
            TableSection (
                type: .images,
                components: [
                    TableComponent (
                        type: .image,
                        config: TableCellConfig(image: Helper.signInImage, color: Helper.primaryColor)
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
                        type: .password,
                        config: TableCellConfig(attributedPlaceholder: "PASSWORD".localized.attributed(color: Helper.primaryColor))
                    )
                ]
            ),
            TableSection (
                type: .buttons,
                components: [
                    TableComponent (
                        type: .button,
                        config: TableCellConfig(title: "SIGN_IN".localized)
                    )
                ]
            ),
            TableSection (
                type: .labels,
                components: [
                    TableComponent (
                        type: .label,
                        config: TableCellConfig(title: "SIGN_UP_AUTHN".localized)
                    )
                ]
            )
        ]
        tableView.reloadData()
    }
    
    func signIn() {
        let request = Authn.SignIn.Request()
        interactor?.signIn(request: request)
    }
}

extension AuthnViewController: AuthnDisplayLogic {
    
    func displaySignIn(viewModel: Authn.SignIn.ViewModel) {
        if viewModel.success {
            router?.routeToGifCollection()
        } else {
            let newConfig = TableCellConfig(image: Helper.signInImage, color: Helper.errorColor)
            setComponentConfig(sectionType: .images, componentType: .image, config: newConfig)
        }
    }
    
    func displayValidationErrors(viewModel: Authn.Validate.ViewModel) {
        var newConfig: TableCellConfig
        
        if let emailError = viewModel.errorMessageEmail {
            newConfig = TableCellConfig(attributedPlaceholder: emailError)
        } else {
            newConfig = TableCellConfig(attributedPlaceholder: "EMAIL".localized.attributed(color: Helper.primaryColor))
        }
        setComponentConfig(sectionType: .textfields, componentType: .email, config: newConfig)
        
        if let passwordError = viewModel.errorMessagePassword {
            newConfig = TableCellConfig(attributedPlaceholder: passwordError)
        } else {
            newConfig = TableCellConfig(attributedPlaceholder: "PASSWORD".localized.attributed(color: Helper.primaryColor))
        }
        setComponentConfig(sectionType: .textfields, componentType: .password, config: newConfig)
        
        tableView.reloadData()
        
        if (viewModel.errorMessageEmail == nil && viewModel.errorMessagePassword == nil) {
            signIn()
        } 
    }
    
    private func setComponentConfig(sectionType: TableSectionType, componentType: TableComponentType, config: TableCellConfig) {
        if let section = sections.firstIndex(where: {$0.type == sectionType}),
           let component = sections[section].components.firstIndex(where: {$0.type == componentType}) {
            sections[section].components[component].config = config
        }
    }
    
    func displayLoadDataSuccess(viewModel: Authn.LoadData.ViewModel) {
        debugPrint("Textfield finished laoding:")
        debugPrint(viewModel.success)
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
        let cell = TableViewCellFactory.configureCell(vc: self, component: sections[indexPath.section].components[indexPath.row])
        return cell
    }
}

extension AuthnViewController: TextFieldTableViewCellDelegate {
    
    func textDidChange(component: TableComponentType, text: String?) {
        let request = Authn.LoadData.Request(component: component, text: text)
        interactor?.loadData(request: request)
    }
}

extension AuthnViewController: ButtonTableViewCellDelegate {
    
    func didTapButton() {
        let request = Authn.Validate.Request()
        interactor?.validate(request: request)
    }
}

extension AuthnViewController: LabelTableViewCellDelegate {
    
    func didTapLabel() {
        router?.routeToRegistration()
    }
}
