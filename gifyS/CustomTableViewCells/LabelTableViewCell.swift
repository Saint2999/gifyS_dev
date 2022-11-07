import SnapKit

final class LabelTableViewCell: UITableViewCell {
    
    lazy var mainLabel: UILabel = {
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
