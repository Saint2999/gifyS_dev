import SnapKit

protocol GifCollDisplayLogic: AnyObject
{
    func displaySomething(viewModel: GifColl.Something.ViewModel)
}

class GifCollViewController: UIViewController, GifCollDisplayLogic, UICollectionViewDataSource, UICollectionViewDelegate
{
    var interactor: GifCollBusinessLogic?
    var router: (NSObjectProtocol & GifCollRoutingLogic & GifCollDataPassing)?
    
    weak var collectionView: UICollectionView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
  
    private func setup()
    {
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
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCollectionView(collectionView: &collectionView)
    }
    
    func setupCollectionView(collectionView: inout UICollectionView?)
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2.2, height: UIScreen.main.bounds.height / 6)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.systemGray6
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        collectionView?.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "GifCollectionViewCell")

        self.view.addSubview(collectionView ?? UICollectionView())
    }
    
    override func viewDidLayoutSubviews()
    {
        self.navigationController?.viewControllers = [self]
    }
    
    func displaySomething(viewModel: GifColl.Something.ViewModel) {
        print("_")
    }
}

extension GifCollViewController
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCollectionViewCell", for: indexPath) as? GifCollectionViewCell
        
        return cell ?? UICollectionViewCell()
    }
}
