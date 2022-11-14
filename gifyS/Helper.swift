import UIKit
class Helper {
    
    static let errorColor: UIColor = UIColor.systemPink
    static let successColor: UIColor = UIColor.systemGreen
    static let clearColor: UIColor = UIColor.clear
    static let backgroundColor: UIColor = UIColor.systemGray6
    static let primaryColor: UIColor = UIColor.systemPurple
    
    static let numberOfGifs: Int = 12
    
    static let gifAPITrendingURL: String = "https://api.giphy.com/v1/gifs/trending"
    static let gifAPISearchURL: String = "https://api.giphy.com/v1/gifs/search"
    static let gifAPIKey: String = "YAmokY0BTS38W0ynjXpAq1uJYmfjHYdj"
    
    static let loginURL: String = "https://mainsoup.backendless.app/api/users/login"
    static let registerURL: String = "https://mainsoup.backendless.app/api/users/register"
    static let ovalImage: UIImage? = UIImage(systemName: "oval.fill")    
    
    static let signInImage: UIImage? = UIImage(systemName: "theatermasks.fill")
    static let signUpImage: UIImage? = UIImage(systemName: "sparkles")
    
    static let imageCellIdentifier: String = "ImageTableViewCell"
    static let textfieldCellIdentifier: String = "TextfieldTableViewCell"
    static let buttonCellIdentifier: String = "ButtonTableViewCell"
    static let labelCellIdentifier: String = "LabelTableViewCell"
    
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
