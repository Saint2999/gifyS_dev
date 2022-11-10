import SnapKit

final class ImageTableViewCell: UITableViewCell {
        
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var signType: Helper.SignType = .signIn {
        didSet {
            switch signType {
            case .signIn:
                mainImageView.image = Helper.signInImage
            
            case .signUp:
                mainImageView.image = Helper.signUpImage
            }
        }
    }
    
    var color: UIColor? {
        get {
            return mainImageView.tintColor
        }
        
        set(newColor) {
            mainImageView.tintColor = newColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = UIColor.clear
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
