import UIKit

struct TableSection {
    
    var type: TableSectionType
    var components: [TableComponent]
}

struct TableComponent {
    
    var type: TableComponentType
    var config: TableCellConfig
}

struct TableCellConfig {
    
    var image: UIImage?
    var color: UIColor?
    var title: String?
    var attributedPlaceholder: NSAttributedString?
}

enum TableSectionType {
    
    case images
    case textfields
    case buttons
    case labels
}

enum TableComponentType {
    
    case image
    case email
    case username
    case password
    case passwordAgain
    case button
    case label
}

