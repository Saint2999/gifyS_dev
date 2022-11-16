import SnapKit
import SDWebImage

protocol LabelCollectionViewCellDelegate: AnyObject {
    
    func didTapAvatar()
}

final class LabelCollectionViewCell: UICollectionViewCell {

    weak var delegate: LabelCollectionViewCellDelegate?
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
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
    
    private var component: HelperGifCollDesc.CollectionComponents = .title {
        didSet {
            switch component {
            case .title:
                mainLabel.numberOfLines = 0
                mainLabel.snp.makeConstraints {
                    make in
                    make.height.centerX.centerY.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.95)
                }
                
            case .avatarAndUsername:
                self.contentView.addSubview(mainImageView)
                
                mainLabel.numberOfLines = 1
                mainLabel.font = .boldSystemFont(ofSize: 36)
                mainLabel.adjustsFontSizeToFitWidth = true
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
                let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
                mainImageView.addGestureRecognizer(labelTapGestureRecognizer)
                
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Helper.backgroundColor
        self.contentView.addSubview(mainLabel)
        
        mainLabel.textAlignment = .center
        mainLabel.textColor = Helper.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupDefaultImage() {
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.image = HelperAuthnReg.signInImage
        mainImageView.tintColor = Helper.primaryColor
    }
    
    @objc func didTapImage() {
        delegate?.didTapAvatar()
    }
}

extension LabelCollectionViewCell: GifDescVCLabelDelegate {
    
    func setComponent(component: HelperGifCollDesc.CollectionComponents) {
        self.component = component
    }
    
    func setLabelText(text: String?) {
        if let text = text {
            mainLabel.text = text
        }
    }
    
    func setLabelImage(url: URL?) {
        if let url = url {
            mainImageView.sd_setImage(with: url)
        } else {
            setupDefaultImage()
        }
    }
}
