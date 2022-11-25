import SnapKit
import SDWebImage

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identificator = "ImageCollectionViewCell"
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20.0
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var component: CollectionComponent! {
        didSet {
            guard let stringURL = component.config.imageURL, let url = URL(string: stringURL)
            else {
                setupDefaultImage()
                return
            }
            mainImageView.sd_setImage(with: url)
            mainImageView.contentMode = .scaleToFill
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
    
    private func setupCellView() {
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = Helper.backgroundColor
    }
    
    private func setupConstraints() {
        mainImageView.snp.makeConstraints {
            make in
            make.centerX.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
        }
    }
    
    private func setupDefaultImage() {
        mainImageView.tintColor = Helper.primaryColor
        mainImageView.image = Helper.signInImage
        mainImageView.contentMode = .scaleAspectFit
    }
    
    func configure(comonent: CollectionComponent) {
        self.component = comonent
    }
}
