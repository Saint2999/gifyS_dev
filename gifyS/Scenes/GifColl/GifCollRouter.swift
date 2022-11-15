import UIKit

@objc protocol GifCollRoutingLogic {
    
    func routeToGifDesc()
}

protocol GifCollDataPassing {
 
    var dataStore: GifCollDataStore? { get }
}

class GifCollRouter: NSObject, GifCollRoutingLogic, GifCollDataPassing {
    
    weak var viewController: GifCollViewController?
    var dataStore: GifCollDataStore?

    func routeToGifDesc() {
        let destination = GifDescViewController(collectionViewLayout: UICollectionViewLayout())
        var destinationDS = destination.router?.dataStore
        passDataToGifDesc(source: dataStore!, destination: &destinationDS!)
        destination.downloadGif()
        self.viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToGifDesc(source: GifCollDataStore, destination: inout GifDescDataStore) {
        destination.theGif = source.theGif
    }
}
