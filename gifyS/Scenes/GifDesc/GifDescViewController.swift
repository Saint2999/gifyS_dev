import UIKit

protocol GifDescDisplayLogic: AnyObject {

    func displayTheGif(viewModel: GifDesc.DownloadGif.ViewModel)
}

protocol GifDescVCImageDelegate: AnyObject {
    
    func setImage(url: URL?)
}

protocol GifDescVCGifDelegate: AnyObject {
    
    func setGif(url: URL?)
}

protocol GifDescVCLabelDelegate: AnyObject {
    
    func setComponent(component: HelperGifCollDesc.CollectionComponents)
    func setLabelImage(url: URL?)
    func setLabelText(text: String?)
}

class GifDescViewController: UICollectionViewController {
    
    var interactor: GifDescBusinessLogic?
    var router: (NSObjectProtocol & GifDescDataPassing)?
    
    weak var imageDelegate: GifDescVCImageDelegate?
    weak var gifDelegate: GifDescVCGifDelegate?
    weak var labelDelegate: GifDescVCLabelDelegate?
    
    private var displayedGif: HelperGifCollDesc.DisplayedGif?
    
    private var sections = [HelperGifCollDesc.CollectionSection]()
    private var cellFactory = CollectionViewCellFactory()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setup()
        setupCollectionView()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    func setup() {
        let viewController = self
        let interactor = GifDescInteractor()
        let presenter = GifDescPresenter()
        let router = GifDescRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        layout.minimumLineSpacing = 20.0
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = Helper.backgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        sections = [
            HelperGifCollDesc.CollectionSection(type: .images, components: [.banner]),
            HelperGifCollDesc.CollectionSection(type: .labels, components: [.title]),
            HelperGifCollDesc.CollectionSection(type: .gifs, components: [.gif]),
            HelperGifCollDesc.CollectionSection(type: .labels, components: [.avatarAndUsername])
        ]
        
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: HelperGifCollDesc.collectionGifCellIdentifier)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: HelperGifCollDesc.collectionImageCellIndentifier)
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: HelperGifCollDesc.collectionLabelCellIdentifier)
    }

    func downloadGif() {
        let request = GifDesc.DownloadGif.Request(placeholder: "Gimme me gif")
        interactor?.downloadGif(request: request)
    }
}

extension GifDescViewController: GifDescDisplayLogic {
    
    func displayTheGif(viewModel: GifDesc.DownloadGif.ViewModel) {
        if let gif = viewModel.gif {
            displayedGif = gif
            collectionView.reloadData()
        }
    }
}

extension GifDescViewController: LabelCollectionViewCellDelegate {
    
    func didTapAvatar() {
        if let url = displayedGif?.profileURL {
            UIApplication.shared.open(URL(string: url)!)
        }
    }
}

extension GifDescViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].components.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellFactory.configureCell (
            viewController: self,
            gif: displayedGif,
            component: sections[indexPath.section].components[indexPath.item],
            indexPath: indexPath
        )
        return cell
    }
}

extension GifDescViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section].components[indexPath.row] {
        case .banner:
            return CGSize(width: collectionView.bounds.width, height: 80.0)
        
        case .title:
            return CGSize(width: collectionView.bounds.width - 40.0, height: 80.0)
            
        case .gif:
            if let height = displayedGif?.originalHeight {
                return CGSize(width: collectionView.bounds.width, height: height > 360.0 ? 360.0 : height)
            } else {
                return CGSize(width: collectionView.bounds.width, height: 300.0)
            }
            
        case .avatarAndUsername:
            return CGSize(width: collectionView.bounds.width - 20.0, height: 140.0)
        }
    }
}
