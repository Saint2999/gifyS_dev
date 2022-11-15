protocol GifDescPresentationLogic {
    
    func presentTheGif(response: GifDesc.DownloadGif.Response)
}

class GifDescPresenter: GifDescPresentationLogic {
    
    weak var viewController: GifDescDisplayLogic?

    func presentTheGif(response: GifDesc.DownloadGif.Response) {
        let viewModel = GifDesc.DownloadGif.ViewModel(gif: response.gif)
        viewController?.displayTheGif(viewModel: viewModel)
    }
}
