import UIKit
class Helper {
    
    static let loginURL: String = "https://mainsoup.backendless.app/api/users/login"
    static let registerURL: String = "https://mainsoup.backendless.app/api/users/register"
    
    static let signInImage: UIImage? = UIImage(systemName: "theatermasks.fill")
    static let signUpImage: UIImage? = UIImage(systemName: "sparkles")
    
    static let errorColor: UIColor = UIColor.systemPink
    static let successColor: UIColor = UIColor.systemGreen
    static let backgroundColor: UIColor = UIColor.systemGray6
    static let primaryColor: UIColor = UIColor.systemPurple
    
    enum SignType {
        
        case signIn
        case signUp
    }
    
    enum UISectionType {
        
        case image
        case textfields
        case button
        case label
    }
    
    enum UIComponents {
        
        case image
        case email
        case username
        case password
        case passwordAgain
        case button
        case label
    }
    
    struct Section {
        
        var type: UISectionType
        var components: [UIComponents]
    }
}
