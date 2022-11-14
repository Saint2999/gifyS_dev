import SnapKit

protocol GifCollDisplayLogic: AnyObject {
    
    func displayGifs(viewModel: GifColl.RequestGifs.ViewModel)
}

protocol GifCollVCCellDelegate: AnyObject {
    
    func setGifImage(url: URL?) 
}

protocol GifCollVCLayoutDelegate: AnyObject {
    
    func purgeCache()
}

class GifCollViewController: UICollectionViewController {
    
    var interactor: GifCollBusinessLogic?
    var router: (NSObjectProtocol & GifCollRoutingLogic)?
    
    private weak var cellDelegate: GifCollVCCellDelegate?
    private weak var layoutDelegate: GifCollVCLayoutDelegate?
    private var searchBar: UISearchBar?
    
    private var displayedGifs: [GifColl.DisplayedGif] = []
    
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
    }
    
    func setupCollectionView() {
        let layout = CustomCollectionViewLayout()
        layout.delegate = self
        layoutDelegate = layout
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.backgroundColor = Helper.backgroundColor
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        collectionView?.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "GifCollectionViewCell")
    
        setupSearchBar()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchBar = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        searchBar?.tintColor = Helper.successColor
        searchBar?.searchTextField.textColor = Helper.primaryColor
        searchBar?.searchTextField.tintColor = Helper.primaryColor
        searchBar?.searchTextField.backgroundColor = Helper.backgroundColor
        searchBar?.setImage(Helper.signInImage?.withTintColor(Helper.primaryColor, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        
        searchBar?.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Gifs", attributes: [NSAttributedString.Key.foregroundColor: Helper.primaryColor])
        searchBar?.searchBarStyle = .minimal
        searchBar?.translatesAutoresizingMaskIntoConstraints = false
        searchBar?.isUserInteractionEnabled = true
        searchBar?.delegate = self
        
        searchBar?.snp.makeConstraints {
            make in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(40)
            make.bottom.equalTo(collectionView.snp.top)
        }
        
        collectionView.addSubview(searchBar ?? UISearchBar())
    }
    
    func requestGifs(query: String?) {
        let request = GifColl.RequestGifs.Request(query: query)
        interactor?.requestGifs(request: request)
    }
}

extension GifCollViewController: GifCollDisplayLogic {
    
    func displayGifs(viewModel: GifColl.RequestGifs.ViewModel) {
        displayedGifs += viewModel.displayedGifs
        self.layoutDelegate?.purgeCache()
        collectionView.reloadData()
        debugPrint(displayedGifs.count)
    }
}

extension GifCollViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedGifs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCollectionViewCell", for: indexPath) as? GifCollectionViewCell
        
        cellDelegate = cell
        cellDelegate?.setGifImage(url: URL(string: displayedGifs[indexPath.row].url))
             
        if (indexPath.row == displayedGifs.count - 3) {
            if searchBar?.text != "" {
                requestGifs(query: searchBar?.text)
            } else {
                requestGifs(query: nil)
            }
        }
        return cell ?? UICollectionViewCell()
    }
}

extension GifCollViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        displayedGifs.removeAll()
        requestGifs(query: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        displayedGifs.removeAll()
        requestGifs(query: searchBar.text)
    }
}

extension GifCollViewController: CustomCollectionViewLayoutDelegate {
    
    func getHeight(indexPath: IndexPath) -> CGFloat {
        return CGFloat((displayedGifs[indexPath.row].height as NSString).floatValue)
    }
}
