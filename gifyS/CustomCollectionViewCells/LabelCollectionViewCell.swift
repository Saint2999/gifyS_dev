import SnapKit
import SDWebImage

protocol LabelCollectionViewCellDelegate: AnyObject {
    
    func didTapAvatar()
}

final class LabelCollectionViewCell: UICollectionViewCell {

    static let identificator = "LabelCollectionViewCell"
    
    weak var delegate: LabelCollectionViewCellDelegate?
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = Helper.primaryColor
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var component: CollectionComponent! {
        didSet {
            if let text = component.config.title {
                mainLabel.text = text
            }
            
            if let url = URL(string: component.config.imageURL!) {
                mainImageView.sd_setImage(with: url)
            } else {
                setupDefaultImage()
            }
            
            switch component.type {
            case .title:
                mainLabel.numberOfLines = 0
                setupTitleCellConstraints()
                
            case .avatarAndUsername:
                self.contentView.addSubview(mainImageView)
                
                mainLabel.numberOfLines = 1
                mainLabel.font = .boldSystemFont(ofSize: 36)
                mainLabel.adjustsFontSizeToFitWidth = true
                
                setupAvatarAndUsernameCellConstraints()
                
                let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
                mainImageView.addGestureRecognizer(labelTapGestureRecognizer)
                
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCellView() {
        self.backgroundColor = Helper.backgroundColor
        self.contentView.addSubview(mainLabel)
    }
    
    private func setupTitleCellConstraints() {
        mainLabel.snp.makeConstraints {
            make in
            make.height.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
        }
    }
    
    private func setupAvatarAndUsernameCellConstraints() {
        mainLabel.snp.makeConstraints {
            make in
            make.centerY.equalToSuperview()
            make.height.right.equalToSuperview().multipliedBy(0.95)
            make.left.equalTo(self.snp.centerX).multipliedBy(1.05)
        }
        
        mainImageView.snp.makeConstraints {
            make in
            make.centerY.equalToSuperview()
            make.height.left.equalToSuperview().multipliedBy(0.95)
            make.right.equalTo(self.snp.centerX).multipliedBy(0.95)
        }
    }
    
    private func setupDefaultImage() {
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.image = Helper.signInImage
        mainImageView.tintColor = Helper.primaryColor
    }
    
    func configure(component: CollectionComponent) {
        self.component = component
    }
    
    @objc func didTapImage() {
        delegate?.didTapAvatar()
    }
}
