import SnapKit

@objc protocol AuthnRoutingLogic {
    
    func routeToRegistration()
    func routeToGifCollection()
}

class AuthnRouter: NSObject, AuthnRoutingLogic {
    
    weak var viewController: AuthnViewController?
  
    func routeToRegistration() {
        self.viewController?.navigationController?.pushViewController(RegViewController(), animated: true)
    }
    
    func routeToGifCollection() {
        self.viewController?.navigationController?.pushViewController(GifCollViewController(), animated: true)
    }
}
