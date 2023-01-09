import UIKit

final class CollectionViewCellFactory {
    
    private init() {}
    
    class func configureCell(vc: GifDescViewController, component: CollectionComponent, indexPath: IndexPath) -> UICollectionViewCell {
        switch component.type {
        case .banner:
            let ImageCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: ImageCollectionViewCell.identificator,
                for: indexPath
            ) as? ImageCollectionViewCell
            ImageCollectionViewCell?.configure(comonent: component)
            return ImageCollectionViewCell ?? UICollectionViewCell()
        
        case .title:
            let LabelCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: LabelCollectionViewCell.identificator,
                for: indexPath
            ) as? LabelCollectionViewCell
            LabelCollectionViewCell?.configure(component: component)
            return LabelCollectionViewCell ?? UICollectionViewCell()
            
        case .gif:
            let GifCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: GifCollectionViewCell.identificator,
                for: indexPath
            ) as? GifCollectionViewCell
            GifCollectionViewCell?.configure(component: component)
            return GifCollectionViewCell ?? UICollectionViewCell()
            
        case .avatarAndUsername:
            let ImageAndLabelCollectionViewCell = vc.collectionView.dequeueReusableCell (
                withReuseIdentifier: LabelCollectionViewCell.identificator,
                for: indexPath
            ) as? LabelCollectionViewCell
            ImageAndLabelCollectionViewCell?.configure(component: component)
            ImageAndLabelCollectionViewCell?.delegate = vc
            return ImageAndLabelCollectionViewCell ?? UICollectionViewCell()
        }
    }
}
