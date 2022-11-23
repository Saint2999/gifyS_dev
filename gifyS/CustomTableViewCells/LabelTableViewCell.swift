import SnapKit

protocol LabelTableViewCellDelegate: AnyObject {
    
    func didTapLabel()
}

final class LabelTableViewCell: UITableViewCell {
    
    static let identificator = "LabelTableViewCell"
    
    weak var delegate: LabelTableViewCellDelegate?
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.isUserInteractionEnabled = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = Helper.successColor
        let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        label.addGestureRecognizer(labelTapGestureRecognizer)
        return label
    }()
    
    private var component: TableComponent! {
        didSet {
            mainLabel.text = component.config.title
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
        self.contentView.addSubview(mainLabel)
        self.backgroundColor = Helper.clearColor
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    func configure(component: TableComponent) {
        self.component = component
    }
    
    @objc func didTapLabel() {
        delegate?.didTapLabel()
    }
}
