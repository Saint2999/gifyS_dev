struct CollectionSection {
    
    var type: CollectionSectionType
    var components: [CollectionComponents]
}

enum CollectionSectionType {
    
    case gifs
    case images
    case labels
}

enum CollectionComponents {
    
    case gif
    case banner
    case avatarAndUsername
    case title
}
