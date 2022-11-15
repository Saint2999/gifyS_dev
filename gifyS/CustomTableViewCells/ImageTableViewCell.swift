import SnapKit

final class ImageTableViewCell: UITableViewCell {
        
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Helper.primaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var signType: HelperAuthnReg.SignType = .signIn {
        didSet {
            switch signType {
            case .signIn:
                mainImageView.image = HelperAuthnReg.signInImage
            
            case .signUp:
                mainImageView.image = HelperAuthnReg.signUpImage
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = Helper.clearColor
        self.selectionStyle = .none
        
        mainImageView.snp.makeConstraints {
            make in
            make.width.height.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageTableViewCell: AuthnVCImageDelegate, RegVCImageDelegate {
    
    func changeImageColor(color: UIColor) {
        mainImageView.tintColor = color
    }
}
