class GifCollWorker {
    
    private var lastMode: GifColl.Mode = GifColl.Mode.Trending
    private var lastPosition: Int = 0
    private var lastSearch: String = ""
    
    private var networkManager = GifCollNetworkManager()
    
    func getGifs(request: GifColl.RequestGifs.Request, completion: @escaping (_ gifData: HelperGifCollDesc.GifDataRaw?) -> Void) {
        var offset: Int?
        var url: String
        
        if request.query != nil {
            url = HelperGifCollDesc.gifAPISearchURL
            if lastMode == .Trending || request.query != lastSearch {
                lastPosition = 0
            }
            lastMode = .Search
            lastSearch = request.query!
            offset = lastPosition
        } else {
            url = HelperGifCollDesc.gifAPITrendingURL
            if lastMode == .Search {
                lastPosition = 0
            }
            lastMode = .Trending
            lastSearch = ""
            offset = lastPosition
        }
        
        let parameters = GifColl.RequestParameters(api_key: HelperGifCollDesc.gifAPIKey, q: request.query, limit: HelperGifCollDesc.numberOfGifs, offset: offset)
        
        let responseType = HelperGifCollDesc.GifDataRaw.self

        networkManager.makeWebRequest(url: url, parameters: parameters, responseType: responseType) {
            response, error in
            if error == nil {
                self.lastPosition += HelperGifCollDesc.numberOfGifs
                completion(response)
            } else {
                debugPrint(error as Any)
                completion(nil)
            }
        }
    }
}
