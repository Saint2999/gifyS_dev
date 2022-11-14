import SnapKit

protocol GifCollPresentationLogic {
    
    func presentGifs(response: GifColl.RequestGifs.Response)
}

class GifCollPresenter: GifCollPresentationLogic {
    
    weak var viewController: GifCollDisplayLogic?
  
    func presentGifs(response: GifColl.RequestGifs.Response) {
        var displayedGifs: [GifColl.DisplayedGif] = []
        
        let rawGifs = response.rawGifs?.data
        
        for gif in rawGifs! {
            displayedGifs.append (
                GifColl.DisplayedGif (
                url: gif.images.fixed_width.url,
                username: gif.username,
                title: gif.title,
                height: gif.images.fixed_width.height
                )
            )
        }
        
        let viewModel = GifColl.RequestGifs.ViewModel(displayedGifs: displayedGifs)
        viewController?.displayGifs(viewModel: viewModel)
    }
}
