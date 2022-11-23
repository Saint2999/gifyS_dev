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
