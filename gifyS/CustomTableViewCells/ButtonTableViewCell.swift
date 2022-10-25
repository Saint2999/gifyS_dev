import SnapKit

class ButtonTableViewCell: UITableViewCell {
    
    let mainButton: UIButtonWithWorkingHighlighted = {
        let button = UIButtonWithWorkingHighlighted(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemPurple
        button.layer.cornerRadius = 20.0
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 42)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainButton)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        mainButton.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class UIButtonWithWorkingHighlighted: UIButton {
    override var isHighlighted: Bool {
        didSet {
                backgroundColor = isHighlighted ? UIColor.systemGreen : UIColor.systemPurple
        }
    }
}