import CoreGraphics
final class HelperGifCollDesc {
    
    // Gif request information
    static let numberOfGifs: Int = 12
    
    static let gifAPITrendingURL: String = "https://api.giphy.com/v1/gifs/trending"
    static let gifAPISearchURL: String = "https://api.giphy.com/v1/gifs/search"
    static let gifAPIKey: String = "YAmokY0BTS38W0ynjXpAq1uJYmfjHYdj"
    
    struct DisplayedGif {
        
        var title: String
        var previewURL: String
        var originalURL: String
        var previewHeight: CGFloat
        var originalHeight: CGFloat
        
        var username: String?
        var avatarURL: String?
        var bannerURL: String?
        var profileURL: String?
        var profileDescription: String?
    }
    
    struct GifDataRaw: Codable {
        
        var data: [GifData]
        
        struct GifData: Codable {
            
            var url: String
            var title: String
            var images: GifTypes
            var user: UserInfo?
            
            struct GifTypes: Codable {
                
                var original: GifSpecific
                var fixed_width: GifSpecific
                var preview_gif: GifSpecific

                struct GifSpecific: Codable {
                    
                    var height: String
                    var url: String
                }
            }
                        
            struct UserInfo: Codable {
                    
                var avatar_url: String?
                var banner_url: String?
                var profile_url: String?
                var username: String?
                var description: String?
            }
        }
    }
    
    // Gif collection/description information
    static let collectionLabelCellIdentifier: String = "LabelCollectionViewCell"
    static let collectionImageCellIndentifier: String = "ImageCollectionViewCell"
    static let collectionGifCellIdentifier: String = "GifCollectionViewCell"
    
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
    
    struct CollectionSection {
        
        var type: CollectionSectionType
        var components: [CollectionComponents]
    }
}
