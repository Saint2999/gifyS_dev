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
        imageView.tintColor = Helper.primaryColor
        imageView.image = Helper.signInImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var component: CollectionComponent! {
        didSet {
            if let url = URL(string: component.config.imageURL!) {
                mainImageView.sd_setImage(with: url)
                mainImageView.contentMode = .scaleAspectFill
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
    
    func configure(comonent: CollectionComponent) {
        self.component = comonent
    }
}
