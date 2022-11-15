import SnapKit
import SDWebImage

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Helper.primaryColor
        imageView.contentMode = .scaleAspectFit
        imageView.image = HelperAuthnReg.signInImage
        imageView.layer.cornerRadius = 30.0
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = Helper.clearColor
        
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
        }
    }
}
