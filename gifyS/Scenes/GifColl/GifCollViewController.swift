import SnapKit

protocol GifCollDisplayLogic: AnyObject {
    
    func displayGifs(viewModel: GifColl.RequestGifs.ViewModel)
    func displayTheGif(viewModel: GifColl.LoadGif.ViewModel)
}

protocol GifCollVCCellDelegate: AnyObject {
    
    func setGifInfo(gif: HelperGifCollDesc.DisplayedGif?)
    func getGifInfo() -> HelperGifCollDesc.DisplayedGif?
}

protocol GifCollVCLayoutDelegate: AnyObject {
    
    func purgeCache()
}

class GifCollViewController: UICollectionViewController {
    
    var interactor: GifCollBusinessLogic?
    var router: (NSObjectProtocol & GifCollRoutingLogic & GifCollDataPassing)?
    
    private weak var cellDelegate: GifCollVCCellDelegate?
    private weak var layoutDelegate: GifCollVCLayoutDelegate?
    private var searchBar: UISearchBar?
    
    private var displayedGifs: [HelperGifCollDesc.DisplayedGif] = []
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setup()
        setupCollectionView()
        requestGifs(query: nil)
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupCollectionView()
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
    
    func setupCollectionView() {
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
        
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: HelperGifCollDesc.collectionGifCellIdentifier)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Helper.successColor

        setupSearchBar()
    }
    
    func setupSearchBar() {
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
        searchBar?.setImage(HelperAuthnReg.signInImage?.withTintColor(Helper.primaryColor, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        
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
    
    func loadGifToDataStore(gif: HelperGifCollDesc.DisplayedGif?) {
        let request = GifColl.LoadGif.Request(gif: gif)
        interactor?.loadGifToDataStore(request: request)
    }
}

extension GifCollViewController: GifCollDisplayLogic {
    
    func displayGifs(viewModel: GifColl.RequestGifs.ViewModel) {
        displayedGifs += viewModel.displayedGifs
        self.layoutDelegate?.purgeCache()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelperGifCollDesc.collectionGifCellIdentifier, for: indexPath) as? GifCollectionViewCell
        
        cellDelegate = cell
        cellDelegate?.setGifInfo(gif: displayedGifs[indexPath.row])
             
        if (indexPath.row == displayedGifs.count - 3) {
            if searchBar?.text != "" {
                requestGifs(query: searchBar?.text)
            } else {
                requestGifs(query: nil)
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate = collectionView.cellForItem(at: indexPath) as? GifCollVCCellDelegate
        loadGifToDataStore(gif: cellDelegate?.getGifInfo())
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
        return displayedGifs[indexPath.item].previewHeight
    }
}
