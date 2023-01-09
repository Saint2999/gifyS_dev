class GifCollWorker {
    
    private var lastMode: GifColl.Mode = GifColl.Mode.Trending
    private var lastPosition: Int = 0
    private var lastSearch: String = ""
        
    func getGifs(request: GifColl.RequestGifs.Request, completion: @escaping (_ gifData: GifDataRaw?) -> Void) {
        var offset: Int?
        var url: String
        
        if let query = request.query {
            url = NetworkHelper.gifAPISearchURL
            if lastMode == .Trending || request.query != lastSearch {
                lastPosition = 0
            }
            lastMode = .Search
            lastSearch = query
            offset = lastPosition
        } else {
            url = NetworkHelper.gifAPITrendingURL
            if lastMode == .Search {
                lastPosition = 0
            }
            lastMode = .Trending
            lastSearch = ""
            offset = lastPosition
        }
        
        if let position = request.position {
            lastPosition = position
            offset = lastPosition
        }
        
        let parameters = GifColl.RequestParameters(api_key: NetworkHelper.gifAPIKey, q: request.query, limit: NetworkHelper.numberOfGifs, offset: offset)
        
        let responseType = GifDataRaw.self

        NetworkManager.makeWebRequest(url: url, method: .get, parameters: parameters, responseType: responseType) {
            response, error in
            if error != nil {
                debugPrint(error as Any)
            }
            self.lastPosition += NetworkHelper.numberOfGifs
            completion(response)
        }
    }
}
