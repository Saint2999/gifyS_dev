import UIKit

final class Helper {
    
    private init() {}
        
    static let signInImage: UIImage = UIImage(systemName: "theatermasks.fill")!
    static let signUpImage: UIImage = UIImage(systemName: "sparkles")!
    static let eyeImage: UIImage = UIImage(systemName: "eye")!
    static let eyeSlashImage: UIImage = UIImage(systemName: "eye.slash")!
    
    static let signInText: String = "Sign In"
    static let signUpText: String = "Sign Up"
    static let emailText: String = "Email"
    static let usernameText: String = "Username"
    static let passwordText: String = "Password"
    static let passwordAgainText: String = "Password Again"
    static let searchGifsText: String = "Search gifs"
    
    static let errorColor: UIColor = UIColor.systemPink
    static let successColor: UIColor = UIColor.systemGreen
    static let clearColor: UIColor = UIColor.clear
    static let backgroundColor: UIColor = UIColor.systemGray6
    static let primaryColor: UIColor = UIColor.systemPurple
}

extension String {
    
    func attributed(color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
}
