enum GifColl {
    
    enum LoadGif {
        
        struct Request {
            
            var gif: HelperGifCollDesc.DisplayedGif?
        }
        
        struct Response {
            
            var success: Bool
        }
        
        struct ViewModel {
            
            var success: Bool
        }
    }
    
    enum RequestGifs {
        
        struct Request {
            
            var query: String?
        }
        
        struct Response {
        
            var rawGifs: HelperGifCollDesc.GifDataRaw?
        }
        
        struct ViewModel {
            
            var displayedGifs: [HelperGifCollDesc.DisplayedGif]
        }
    }
    
    struct RequestParameters: Encodable {
        
        var api_key: String
        var q: String?
        var limit: Int?
        var offset: Int?
    }
    
    enum Mode {
        
        case Trending
        case Search
    }
}
