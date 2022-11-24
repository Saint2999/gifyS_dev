import UIKit

struct CollectionSection {
    
    var type: CollectionSectionType
    var components: [CollectionComponent]
}

struct CollectionComponent {
    
    var type: CollectionComponentType
    var config: CollectionCellConfig
}

struct CollectionCellConfig {
    
    var gif: DisplayedGif?
    var imageURL: String?
    var title: String?
}

enum CollectionSectionType {
    
    case gifs
    case images
    case labels
}

enum CollectionComponentType {
    
    case gif
    case banner
    case avatarAndUsername
    case title
}
