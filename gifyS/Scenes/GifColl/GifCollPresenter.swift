import UIKit

protocol GifCollPresentationLogic {
    
    func presentGifs(response: GifColl.RequestGifs.Response)
    func presentLoadGifSuccess(response: GifColl.LoadGif.Response)
}

class GifCollPresenter: GifCollPresentationLogic {
    
    weak var viewController: GifCollDisplayLogic?
  
    func presentGifs(response: GifColl.RequestGifs.Response) {
        var displayedGifs: [CollectionComponent] = []
        
        let rawGifs = response.rawGifs?.data
        
        for gif in rawGifs! {
            displayedGifs.append (
                CollectionComponent(
                    type: .gif,
                    config: CollectionCellConfig (
                        gif: DisplayedGif (
                            title: gif.title,
                            previewURL: gif.images.preview_gif.url,
                            originalURL: gif.images.original.url,
                            previewHeight: CGFloat((gif.images.fixed_width.height as NSString).floatValue),
                            originalHeight: CGFloat((gif.images.original.height as NSString).floatValue),
                            username: gif.user?.username,
                            avatarURL: gif.user?.avatar_url,
                            bannerURL: gif.user?.banner_url,
                            profileURL: gif.user?.profile_url,
                            profileDescription: gif.user?.description
                        )
                    )
                )
            )
        }
        
        let viewModel = GifColl.RequestGifs.ViewModel(displayedGifs: displayedGifs)
        viewController?.displayGifs(viewModel: viewModel)
    }
    
    func presentLoadGifSuccess(response: GifColl.LoadGif.Response) {
        let viewModel = GifColl.LoadGif.ViewModel(success: response.success)
        viewController?.displayTheGif(viewModel: viewModel)
    }
}
