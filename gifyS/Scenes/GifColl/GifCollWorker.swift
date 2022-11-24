class GifCollWorker {
    
    private var lastMode: GifColl.Mode = GifColl.Mode.Trending
    private var lastPosition: Int = 0
    private var lastSearch: String = ""
        
    func getGifs(request: GifColl.RequestGifs.Request, completion: @escaping (_ gifData: GifDataRaw?) -> Void) {
        var offset: Int?
        var url: String
        
        if request.query != nil {
            url = NetworkHelper.gifAPISearchURL
            if lastMode == .Trending || request.query != lastSearch {
                lastPosition = 0
            }
            lastMode = .Search
            lastSearch = request.query!
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
        
        let parameters = GifColl.RequestParameters(api_key: NetworkHelper.gifAPIKey, q: request.query, limit: Helper.numberOfGifs, offset: offset)
        
        let responseType = GifDataRaw.self

        NetworkManager.makeWebRequest(url: url, method: .get, parameters: parameters, responseType: responseType) {
            response, error in
            if error == nil {
                self.lastPosition += Helper.numberOfGifs
                completion(response)
            } else {
                debugPrint(error as Any)
                completion(nil)
            }
        }
    }
}
