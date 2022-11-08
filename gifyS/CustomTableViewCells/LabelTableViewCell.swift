import SnapKit

protocol LabelTableViewCellDelegate: AnyObject {
    
    func changeText(text: String)
    func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
}

final class LabelTableViewCell: UITableViewCell {
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension LabelTableViewCell: LabelTableViewCellDelegate {
    
    func changeText(text: String) {
        mainLabel.text = text
    }
    
    func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        mainLabel.addGestureRecognizer(gestureRecognizer)
    }
}
