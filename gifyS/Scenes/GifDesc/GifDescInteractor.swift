protocol GifDescBusinessLogic {

    func downloadGif(request: GifDesc.DownloadGif.Request)
}

protocol GifDescDataStore {

    var theGif: DisplayedGif? {get set}
}

class GifDescInteractor: GifDescBusinessLogic, GifDescDataStore {
  
    var presenter: GifDescPresentationLogic?
    var theGif: DisplayedGif?

    func downloadGif(request: GifDesc.DownloadGif.Request) {
        var response:GifDesc.DownloadGif.Response
        if let gif = theGif {
            response = GifDesc.DownloadGif.Response(gif: gif)
        } else {
            response = GifDesc.DownloadGif.Response(gif: nil)
        }
        presenter?.presentTheGif(response: response)
    }
}
