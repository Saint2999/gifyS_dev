import UIKit

protocol GifDescDisplayLogic: AnyObject {

    func displayTheGif(viewModel: GifDesc.DownloadGif.ViewModel)
}

class GifDescViewController: UICollectionViewController {
    
    var interactor: GifDescBusinessLogic?
    var router: (NSObjectProtocol & GifDescDataPassing)?
        
    private var sections = [CollectionSection]()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setup()
        setupCollectionView()
        downloadGif()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    private func setup() {
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
    
    private func setupCollectionView() {
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
        
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCollectionViewCell.identificator)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identificator)
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: LabelCollectionViewCell.identificator)
    }

    private func setupViewModel(gif: DisplayedGif) {
        sections = [
            CollectionSection (
                type: .gifs,
                components: [
                    CollectionComponent(type: .gif, config: CollectionCellConfig(gif: gif))
                ]
            ),
            CollectionSection (
                type: .labels,
                components: [
                    CollectionComponent(type: .title, config: CollectionCellConfig(title: gif.title)),
                    CollectionComponent(type: .avatarAndUsername, config: CollectionCellConfig(imageURL: gif.avatarURL, title: gif.username))
                ]
            ),
            CollectionSection (
                type: .images,
                components: [
                    CollectionComponent(type: .banner, config: CollectionCellConfig(imageURL: gif.bannerURL))
                ]
            )
        ]
        collectionView.reloadData()
    }
    
    func downloadGif() {
        let request = GifDesc.DownloadGif.Request()
        interactor?.downloadGif(request: request)
    }
}

extension GifDescViewController: GifDescDisplayLogic {
    
    func displayTheGif(viewModel: GifDesc.DownloadGif.ViewModel) {
        if let gif = viewModel.gif {
            setupViewModel(gif: gif)
        }
    }
}

extension GifDescViewController: LabelCollectionViewCellDelegate {
    
    func didTapAvatar() {
        if let stringURL = sections.first(where: {$0.type == .gifs})?.components.first(where: {$0.type == .gif})?.config.gif?.profileURL,
        let url = URL(string: stringURL) {
            UIApplication.shared.open(url)
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
        let cell = CollectionViewCellFactory.configureCell(vc: self, component: sections[indexPath.section].components[indexPath.row], indexPath: indexPath)
        return cell
    }
}

extension GifDescViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section].components[indexPath.row].type {
        case .banner:
            if let _ = URL(string: sections[indexPath.section].components[indexPath.row].config.imageURL ?? "") {
                return CGSize(width: collectionView.bounds.width, height: 120.0)
            } else {
                return CGSize(width: collectionView.bounds.width, height: 0.0)
            }
            
        case .title:
            return CGSize(width: collectionView.bounds.width - 40.0, height: 50.0)
            
        case .gif:
            if let height = sections.first(where: {$0.type == .gifs})?.components.first(where: {$0.type == .gif})?.config.gif?.originalHeight {
                return CGSize(width: collectionView.bounds.width, height: height > collectionView.bounds.width ? collectionView.bounds.width : height)
            } else {
                return CGSize(width: collectionView.bounds.width, height: 300.0)
            }
            
        case .avatarAndUsername:
            return CGSize(width: collectionView.bounds.width - 20.0, height: 140.0)
        }
    }
}
