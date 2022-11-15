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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = HelperAuthnReg.signInImage
        imageView.tintColor = Helper.primaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var component: HelperGifCollDesc.CollectionComponents = .label {
        didSet {
            switch component {
            case .label:
                mainLabel.snp.makeConstraints {
                    make in
                    make.height.centerX.centerY.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.95)
                }
                
            case .imageAndLabel:
                self.contentView.addSubview(mainImage)
                mainLabel.font = .boldSystemFont(ofSize: 40)
                mainLabel.snp.makeConstraints {
                    make in
                    make.height.right.equalToSuperview().multipliedBy(0.95)
                    make.left.equalTo(self.snp.centerX).multipliedBy(0.95)
                }
                
                mainImage.snp.makeConstraints {
                    make in
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.85)
                    make.left.equalToSuperview().multipliedBy(0.95)
                    make.right.equalTo(self.snp.centerX).multipliedBy(0.95)
                }
                let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
                mainImage.addGestureRecognizer(labelTapGestureRecognizer)
                
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainLabel)
        self.backgroundColor = Helper.lighGrayColor
        self.layer.cornerRadius = 20.0
        
        mainLabel.textAlignment = .center
        mainLabel.textColor = Helper.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            mainImage.sd_setImage(with: url)
        }
    }
}
