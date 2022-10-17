import SnapKit

@objc protocol RegRoutingLogic
{
    func routeToGifCollection()
}

class RegRouter: NSObject, RegRoutingLogic
{
    weak var viewController: RegViewController?
    
    func routeToGifCollection()
    {
        self.viewController?.navigationController?.pushViewController(GifCollViewController(), animated: true)
    }
}
