import SnapKit

protocol GifCollPresentationLogic {
    
    func presentSomething(response: GifColl.Something.Response)
}

class GifCollPresenter: GifCollPresentationLogic {
    
    weak var viewController: GifCollDisplayLogic?
  
    func presentSomething(response: GifColl.Something.Response) {
        let viewModel = GifColl.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
