import UIKit

final class CollectionViewCellFactory {
    
    func configureCell(viewController: GifDescViewController?, gif: HelperGifCollDesc.DisplayedGif?, component: HelperGifCollDesc.CollectionComponents, indexPath: IndexPath) -> UICollectionViewCell {
        guard let vc = viewController else { return UICollectionViewCell() }
        
        switch component {
        case .banner:
            let ImageCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: HelperGifCollDesc.collectionImageCellIndentifier,
                for: indexPath
            ) as? ImageCollectionViewCell
            vc.imageDelegate = ImageCollectionViewCell
            if let url = gif?.bannerURL {
                vc.imageDelegate?.setImage(url: URL(string: url))
            }
            return ImageCollectionViewCell ?? UICollectionViewCell()
        
        case .title:
            let LabelCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: HelperGifCollDesc.collectionLabelCellIdentifier,
                for: indexPath
            ) as? LabelCollectionViewCell
            vc.labelDelegate = LabelCollectionViewCell
            vc.labelDelegate?.setComponent(component: component)
            vc.labelDelegate?.setLabelText(text: gif?.title)
            return LabelCollectionViewCell ?? UICollectionViewCell()
            
        case .gif:
            let GifCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: HelperGifCollDesc.collectionGifCellIdentifier,
                for: indexPath
            ) as? GifCollectionViewCell
            vc.gifDelegate = GifCollectionViewCell
            if let url = gif?.originalURL {
                vc.gifDelegate?.setGif(url: URL(string: url))
            }
            return GifCollectionViewCell ?? UICollectionViewCell()
            
        case .avatarAndUsername:
            let ImageAndLabelCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: HelperGifCollDesc.collectionLabelCellIdentifier,
                for: indexPath
            ) as? LabelCollectionViewCell
            vc.labelDelegate = ImageAndLabelCollectionViewCell
            vc.labelDelegate?.setComponent(component: component)
            if let url = gif?.avatarURL {
                vc.labelDelegate?.setLabelImage(url: URL(string: url))
            }
            vc.labelDelegate?.setLabelText(text: gif?.username)
            ImageAndLabelCollectionViewCell?.delegate = vc
            return ImageAndLabelCollectionViewCell ?? UICollectionViewCell()
        }
    }
}
