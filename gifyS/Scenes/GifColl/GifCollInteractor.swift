import SnapKit

protocol GifCollBusinessLogic {
    
    func requestGifs(request: GifColl.RequestGifs.Request)
}

class GifCollInteractor: GifCollBusinessLogic {
    
    var presenter: GifCollPresentationLogic?
    var worker = GifCollWorker()
    
    func requestGifs(request: GifColl.RequestGifs.Request) {
        worker.getGifs(request: request) {
            result in
            if result != nil {
                let response = GifColl.RequestGifs.Response(rawGifs: result)
                self.presenter?.presentGifs(response: response)
            }
        }
    }
    
}
