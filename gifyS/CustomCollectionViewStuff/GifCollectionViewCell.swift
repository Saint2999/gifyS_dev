import SnapKit

final class GifCollectionViewCell: UICollectionViewCell {
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = UIColor.systemGray5
        self.layer.cornerRadius = 20
        
        mainImageView.image = UIImage(systemName: "sparkles")
        mainImageView.snp.makeConstraints {
            make in
            make.width.height.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
