import SnapKit

enum GifColl {
    
    enum Mode {
        
        case Trending
        case Search
    }
    
    struct DisplayedGif {
        
        var url: String
        var username: String
        var title: String
        var height: String
    }
    
    enum RequestGifs {
        
        struct Request {
            
            var query: String?
        }
        
        struct Response {
        
            var rawGifs: GifDataRaw?
        }
        
        struct ViewModel {
            
            var displayedGifs: [DisplayedGif]
        }
    }
    
    struct RequestParameters: Encodable {
        
        var api_key: String
        var q: String?
        var limit: Int?
        var offset: Int?
    }
    
    struct GifDataRaw: Codable {
        
        var data: [GifData]
        
        struct GifData: Codable {
            
            var url: String
            var username: String
            var title: String
            var images: GifTypes
        
            struct GifTypes: Codable {
                
                var original: GifSpecific
                var original_still: GifSpecific
                var fixed_height: GifSpecific
                var fixed_width: GifSpecific
            
                struct GifSpecific: Codable {
                    
                    var height: String
                    var width: String
                    var url: String
                }
            }
        }
    }
}
