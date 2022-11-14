import SnapKit
import SDWebImage

final class GifCollectionViewCell: UICollectionViewCell {
    
    private lazy var mainGifView: SDAnimatedImageView = {
        let gifView = SDAnimatedImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        return gifView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainGifView)
    
        mainGifView.snp.makeConstraints {
            make in
            make.width.height.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainGifView.stopAnimating()
    }
}

extension GifCollectionViewCell: GifCollVCCellDelegate {
    
    func setGifImage(url: URL?) {
        guard let url = url else { return }
        mainGifView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainGifView.sd_setImage(with: url)
    }
}
