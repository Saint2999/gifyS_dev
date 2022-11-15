import Foundation

protocol GifDescDataPassing {
    
    var dataStore: GifDescDataStore? { get set}
}

class GifDescRouter: NSObject, GifDescDataPassing {
    
  weak var viewController: GifDescViewController?
  var dataStore: GifDescDataStore?
}
