import UIKit

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func attributed(color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
