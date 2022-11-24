protocol GifCollBusinessLogic {
    
    func requestGifs(request: GifColl.RequestGifs.Request)
    func loadGifToDataStore(request: GifColl.LoadGif.Request)
}

protocol GifCollDataStore {
    
    var theGif: DisplayedGif? {get set}
}

class GifCollInteractor: GifCollBusinessLogic, GifCollDataStore {
    
    var presenter: GifCollPresentationLogic?
    var worker = GifCollWorker()
    
    var theGif: DisplayedGif?
    
    func requestGifs(request: GifColl.RequestGifs.Request) {
        worker.getGifs(request: request) {
            gifData in
            if let gifData = gifData {
                let response = GifColl.RequestGifs.Response(rawGifs: gifData)
                self.presenter?.presentGifs(response: response)
            }
        }
    }
    
    func loadGifToDataStore(request: GifColl.LoadGif.Request) {
        var response: GifColl.LoadGif.Response
        if let gif = request.gif {
            theGif = gif
            response = GifColl.LoadGif.Response(success: true)
        } else {
            response = GifColl.LoadGif.Response(success: false)
        }
        presenter?.presentLoadGifSuccess(response: response)
    }
}
