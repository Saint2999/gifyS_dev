import SnapKit

protocol ImageTableViewCellDelegate: AnyObject {
    
    func changeImage(imageName: String)
    func changeColor(color: UIColor)
}
final class ImageTableViewCell: UITableViewCell {
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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

extension ImageTableViewCell: ImageTableViewCellDelegate {
    
    func changeImage(imageName: String) {
        mainImageView.image = UIImage(systemName: imageName)
    }
    
    func changeColor(color: UIColor) {
        mainImageView.tintColor = color
    }
}
