import SnapKit
import SDWebImage

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20.0
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        imageView.tintColor = Helper.primaryColor
        imageView.image = HelperAuthnReg.signInImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = Helper.backgroundColor
        
        mainImageView.snp.makeConstraints {
            make in
            make.centerX.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageCollectionViewCell: GifDescVCImageDelegate {
    
    func setImage(url: URL?) {
        if let url = url {
            mainImageView.sd_setImage(with: url)
            mainImageView.contentMode = .scaleAspectFill
        }
    }
}
