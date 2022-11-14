import SnapKit

@objc protocol AuthnRoutingLogic {
    
    func routeToRegistration()
    func routeToGifCollection()
}

class AuthnRouter: NSObject, AuthnRoutingLogic {
    
    weak var viewController: AuthnViewController?
  
    func routeToRegistration() {
        self.viewController?.navigationController?.pushViewController(RegViewController(nibName: nil, bundle: nil), animated: true)
    }
    
    func routeToGifCollection() {
        self.viewController?.navigationController?.pushViewController(GifCollViewController(collectionViewLayout: UICollectionViewLayout()), animated: true)
    }
}
