import SnapKit

protocol GifCollBusinessLogic {
    
    func doSomething(request: GifColl.Something.Request)
}

protocol GifCollDataStore {

    //var name: String { get set }
}

class GifCollInteractor: GifCollBusinessLogic, GifCollDataStore {
    
    var presenter: GifCollPresentationLogic?
    var worker: GifCollWorker?
    //var name: String = ""
  
    func doSomething(request: GifColl.Something.Request) {
        worker = GifCollWorker()
        worker?.doSomeWork()
    
        let response = GifColl.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
