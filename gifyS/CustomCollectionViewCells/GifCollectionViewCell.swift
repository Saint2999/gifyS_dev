import SnapKit
import SDWebImage

final class GifCollectionViewCell: UICollectionViewCell {
    
    static let identificator = "GifCollectionViewCell"
        
    private lazy var mainGifView: SDAnimatedImageView = {
        let gifView = SDAnimatedImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.layer.cornerRadius = 8.0
        gifView.clipsToBounds = true
        return gifView
    }()
    
    private var component: CollectionComponent! {
        didSet {
            mainGifView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            mainGifView.sd_imageTransition = .fade
            if let gif = component.config.gif {
                mainGifView.sd_setImage(with: URL(string: gif.previewURL))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainGifView.sd_setImage(with: nil)
    }
    
    private func setupCellView() {
        self.contentView.addSubview(mainGifView)
    }
    
    private func setupConstraints() {
        mainGifView.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.98)
        }
    }
    
    func configure(component: CollectionComponent) {
        self.component = component
    }
}
