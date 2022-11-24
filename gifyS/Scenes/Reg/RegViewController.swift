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
                        config: TableCellConfig(attributedPlaceholder: Helper.attributedString(text: Helper.emailText, color: Helper.primaryColor))
                    ),
                    TableComponent (
                        type: .username,
                        config: TableCellConfig(attributedPlaceholder: Helper.attributedString(text: Helper.usernameText, color: Helper.primaryColor))
                    ),
                    TableComponent (
                        type: .password,
                        config: TableCellConfig(attributedPlaceholder: Helper.attributedString(text: Helper.passwordText, color: Helper.primaryColor))
                    ),
                    TableComponent (
                        type: .passwordAgain,
                        config: TableCellConfig(attributedPlaceholder: Helper.attributedString(text: Helper.passwordAgainText, color: Helper.primaryColor))
                    )
                ]
            ),
            TableSection (
                type: .buttons,
                components: [
                    TableComponent (
                        type: .button,
                        config: TableCellConfig(title: Helper.signUpText)
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
}

extension RegViewController: RegDisplayLogic {

    func displaySignUp(viewModel: Reg.SignUp.ViewModel) {
        if viewModel.success {
            router?.routeToGifCollection()
        } else {
            if let section = sections.firstIndex(where: {$0.type == .images}),
               let component = sections[section].components.firstIndex(where: {$0.type == .image}) {
                sections[section].components[component].config = TableCellConfig(image: Helper.signInImage, color: Helper.errorColor)
            }
        }
    }
    
    func displayValidationErrors(viewModel: Reg.Validate.ViewModel) {
        if let section = sections.firstIndex(where: {$0.type == .textfields}),
           let component = sections[section].components.firstIndex(where: {$0.type == .email}) {
            if let emailError = viewModel.errorMessageEmail {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: emailError)
            } else {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: Helper.attributedString(text: Helper.emailText, color: Helper.primaryColor))
            }
        }
        if let section = sections.firstIndex(where: {$0.type == .textfields}),
           let component = sections[section].components.firstIndex(where: {$0.type == .username}) {
            if let usernameError = viewModel.errorMessageUsername {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: usernameError)
            } else {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: Helper.attributedString(text: Helper.usernameText, color: Helper.primaryColor))
            }
        }
        if let section = sections.firstIndex(where: {$0.type == .textfields}),
           let component = sections[section].components.firstIndex(where: {$0.type == .password}) {
            if let passwordError = viewModel.errorMessagePassword {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: passwordError)
            } else {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: Helper.attributedString(text: Helper.passwordText, color: Helper.primaryColor))
            }
        }
        if let section = sections.firstIndex(where: {$0.type == .textfields}),
           let component = sections[section].components.firstIndex(where: {$0.type == .passwordAgain}) {
            if let passwordAgainError = viewModel.errorMessagePasswordAgain {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: passwordAgainError)
            } else {
                sections[section].components[component].config = TableCellConfig(title: nil, attributedPlaceholder: Helper.attributedString(text: Helper.passwordAgainText, color: Helper.primaryColor))
            }
        }
        tableView.reloadData()
        if (viewModel.errorMessageEmail == nil && viewModel.errorMessageUsername == nil && viewModel.errorMessagePassword == nil && viewModel.errorMessagePasswordAgain == nil) {
            signUp()
        }
    }
    
    func displayLoadDataSuccess(viewModel: Reg.LoadData.ViewModel) {
        debugPrint("Textfield finished laoding:")
        debugPrint(viewModel.success)
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
