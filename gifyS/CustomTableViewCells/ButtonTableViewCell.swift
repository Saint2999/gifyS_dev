import SnapKit

protocol ButtonTableViewCellDelegate: AnyObject {

    func didTapButton()
}

final class ButtonTableViewCell: UITableViewCell {
    
    static let identificator = "ButtonTableViewCell"
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    private lazy var mainButton: UIButtonWithWorkingHighlighted = {
        let button = UIButtonWithWorkingHighlighted(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Helper.primaryColor
        button.layer.cornerRadius = 20.0
        button.setTitleColor(Helper.backgroundColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 42)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private var component: TableComponent! {
        didSet {
            mainButton.setTitle(component.config.title, for: .normal)
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
        self.contentView.addSubview(mainButton)
        self.backgroundColor = Helper.clearColor
        self.selectionStyle = .none
    }
    
    private func setupConstraints() {
        mainButton.snp.makeConstraints {
            make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    func configure(component: TableComponent) {
        self.component = component
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
