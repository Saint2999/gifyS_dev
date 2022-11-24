enum GifColl {
    
    enum LoadGif {
        
        struct Request {
            
            var gif: DisplayedGif?
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
        
            var rawGifs: GifDataRaw?
        }
        
        struct ViewModel {
            
            var displayedGifs: [CollectionComponent]
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
