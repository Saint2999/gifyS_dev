import SnapKit

final class ImageTableViewCell: UITableViewCell {
        
    static let identificator = "ImageTableViewCell"
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var component: TableComponent! {
        didSet {
            mainImageView.image = component.config.image
            mainImageView.tintColor = component.config.color
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCellView() {
        self.contentView.addSubview(mainImageView)
        self.backgroundColor = Helper.clearColor
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        mainImageView.snp.makeConstraints {
            make in
            make.width.height.equalToSuperview()
        }
    }
    
    func configure(component: TableComponent) {
        self.component = component
    }
}
