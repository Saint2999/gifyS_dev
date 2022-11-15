import UIKit

final class HelperAuthnReg {
    
    //Authentication and registration information
    static let loginURL: String = "https://mainsoup.backendless.app/api/users/login"
    static let registerURL: String = "https://mainsoup.backendless.app/api/users/register"
    
    static let signInImage: UIImage? = UIImage(systemName: "theatermasks.fill")
    static let signUpImage: UIImage? = UIImage(systemName: "sparkles")
    
    static let tableImageCellIdentifier: String = "ImageTableViewCell"
    static let tableTextfieldCellIdentifier: String = "TextfieldTableViewCell"
    static let tableButtonCellIdentifier: String = "ButtonTableViewCell"
    static let tableLabelCellIdentifier: String = "LabelTableViewCell"
    
    enum SignType {
        
        case signIn
        case signUp
    }

    enum TableSectionType {
        
        case images
        case textfields
        case buttons
        case labels
    }
    
    enum TableComponents {
        
        case image
        case email
        case username
        case password
        case passwordAgain
        case button
        case label
    }
    
    struct TableSection {
        
        var type: TableSectionType
        var components: [TableComponents]
    }
}
