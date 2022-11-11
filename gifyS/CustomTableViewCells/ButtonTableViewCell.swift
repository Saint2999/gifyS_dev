import SnapKit

protocol ButtonTableViewCellDelegate: AnyObject {

    func didTapButton()
}

final class ButtonTableViewCell: UITableViewCell {
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    private lazy var mainButton: UIButtonWithWorkingHighlighted = {
        let button = UIButtonWithWorkingHighlighted(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Helper.primaryColor
        button.layer.cornerRadius = 20.0
        button.setTitleColor(Helper.backgroundColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 42)
        return button
    }()
    
    var signType: Helper.SignType = .signIn {
        didSet {
            switch signType {
            case .signIn:
                mainButton.setTitle("Sign In", for: .normal)
            
            case .signUp:
                mainButton.setTitle("Sign Up", for: .normal)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainButton)
        self.backgroundColor = Helper.clearColor
        self.selectionStyle = .none
        
        mainButton.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        mainButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func didTapButton() {
        delegate?.didTapButton()
    }

}

class UIButtonWithWorkingHighlighted: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Helper.successColor : Helper.primaryColor
        }
    }
}
