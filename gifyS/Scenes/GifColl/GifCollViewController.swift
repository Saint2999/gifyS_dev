import SnapKit

protocol GifCollDisplayLogic: AnyObject {
    
    func displayGifs(viewModel: GifColl.RequestGifs.ViewModel)
    func displayTheGif(viewModel: GifColl.LoadGif.ViewModel)
}

protocol GifCollVCLayoutDelegate: AnyObject {
    
    func purgeCache()
}

class GifCollViewController: UICollectionViewController {
    
    var interactor: GifCollBusinessLogic?
    var router: (NSObjectProtocol & GifCollRoutingLogic & GifCollDataPassing)?
    
    private weak var layoutDelegate: GifCollVCLayoutDelegate?
    private weak var searchBar: UISearchBar?
    
    private var displayedGifs: [CollectionComponent] = []
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setup()
        setupCollectionView()
        setupSearchBar()
        setupBackButton()
        requestGifs(query: nil)
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [self]
    }
    
    private func setup() {
        let viewController = self
        let interactor = GifCollInteractor()
        let presenter = GifCollPresenter()
        let router = GifCollRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupCollectionView() {
        let layout = CustomCollectionViewLayout()
        layout.delegate = self
        layoutDelegate = layout
    
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = Helper.backgroundColor
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCollectionViewCell.identificator)
    }
    
    private func setupBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Helper.successColor
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchBar = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear    
        appearance.backgroundColor = Helper.backgroundColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        searchBar?.tintColor = Helper.successColor
        searchBar?.searchTextField.textColor = Helper.primaryColor
        searchBar?.searchTextField.tintColor = Helper.primaryColor
        searchBar?.searchTextField.backgroundColor = Helper.backgroundColor
        searchBar?.setImage(Helper.signInImage.withTintColor(Helper.primaryColor, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        
        searchBar?.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Gifs", attributes: [NSAttributedString.Key.foregroundColor: Helper.primaryColor])
        searchBar?.searchBarStyle = .minimal
        searchBar?.translatesAutoresizingMaskIntoConstraints = false
        searchBar?.isUserInteractionEnabled = true
        searchBar?.delegate = self
        
        collectionView.addSubview(searchBar ?? UISearchBar())
        
        searchBar?.snp.makeConstraints {
            make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
        }
    }
    
    func requestGifs(query: String?) {
        let request = GifColl.RequestGifs.Request(query: query)
        interactor?.requestGifs(request: request)
    }
    
    func loadGifToDataStore(gif: DisplayedGif?) {
        let request = GifColl.LoadGif.Request(gif: gif)
        interactor?.loadGifToDataStore(request: request)
    }
}

extension GifCollViewController: GifCollDisplayLogic {
    
    func displayGifs(viewModel: GifColl.RequestGifs.ViewModel) {
        displayedGifs += viewModel.displayedGifs
        layoutDelegate?.purgeCache()
        collectionView.reloadData()
    }
    
    func displayTheGif(viewModel: GifColl.LoadGif.ViewModel) {
        if viewModel.success == true {
            router?.routeToGifDesc()
        }
    }
}

extension GifCollViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedGifs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCollectionViewCell.identificator, for: indexPath) as? GifCollectionViewCell
        cell?.configure(component: displayedGifs[indexPath.row])
        if (indexPath.row == displayedGifs.count - 8) {
            if searchBar?.text != "" {
                requestGifs(query: searchBar?.text)
            } else {
                requestGifs(query: nil)
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let gif = displayedGifs[indexPath.row].config.gif {
            loadGifToDataStore(gif: gif)
        }
    }
}

extension GifCollViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        displayedGifs.removeAll()
        requestGifs(query: searchBar.text)
    }
}

extension GifCollViewController: CustomCollectionViewLayoutDelegate {
    
    func getHeight(indexPath: IndexPath) -> CGFloat {
        return displayedGifs[indexPath.item].config.gif?.previewHeight ?? 180
    }
}
