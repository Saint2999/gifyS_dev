import SnapKit
import SDWebImage

final class GifCollectionViewCell: UICollectionViewCell {
        
    private var gifInfo: HelperGifCollDesc.DisplayedGif?
    
    private lazy var mainGifView: SDAnimatedImageView = {
        let gifView = SDAnimatedImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.layer.cornerRadius = 20.0
        gifView.clipsToBounds = true
        return gifView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainGifView)
        
        mainGifView.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.95)
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
    
    func setGifInfo(gif: HelperGifCollDesc.DisplayedGif?) {
        gifInfo = gif
        mainGifView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        if let url = gif?.previewURL {
            mainGifView.sd_setImage(with: URL(string: url))
        }
    }
    
    func getGifInfo() -> HelperGifCollDesc.DisplayedGif? {
        return gifInfo
    }
}

extension GifCollectionViewCell: GifDescVCGifDelegate {
    
    func setGif(url: URL?) {
        if let url = url {
            mainGifView.sd_setImage(with: url)
        } else {
            mainGifView.image = Helper.signUpImage
        }
    }
}
