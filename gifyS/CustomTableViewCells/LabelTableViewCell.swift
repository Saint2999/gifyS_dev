import SnapKit

protocol LabelTableViewCellDelegate: AnyObject {
    
    func didTapLabel()
}

final class LabelTableViewCell: UITableViewCell {
    
    weak var delegate: LabelTableViewCellDelegate?
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var signType: Helper.SignType = .signIn {
        didSet {
            switch signType {
            case .signIn:
                mainLabel.text = "Sign Up"
            
            case .signUp:
                mainLabel.text = "Sign In"
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainLabel)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        mainLabel.isUserInteractionEnabled = true
        mainLabel.textAlignment = NSTextAlignment.center
        mainLabel.textColor = UIColor.systemGreen
        
        mainLabel.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        mainLabel.addGestureRecognizer(labelTapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func didTapLabel() {
        delegate?.didTapLabel()
    }
}
