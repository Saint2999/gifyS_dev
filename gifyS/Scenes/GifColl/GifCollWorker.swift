import SnapKit
import Alamofire

class GifCollWorker {
    
    private var lastMode: GifColl.Mode = GifColl.Mode.Trending
    private var lastPosition: Int = 0
    private var lastSearch: String = ""
    
    private var networkManager = GifCollNetworkManager()
    
    func getGifs(request: GifColl.RequestGifs.Request, completion: @escaping (_ response: GifColl.GifDataRaw?) -> Void) {
        var offset: Int?
        var url: String
        
        if request.query != nil {
            url = Helper.gifAPISearchURL
            if lastMode == .Trending || request.query != lastSearch {
                lastPosition = 0
            }
            lastMode = .Search
            lastSearch = request.query!
            offset = lastPosition
        } else {
            url = Helper.gifAPITrendingURL
            if lastMode == .Search {
                lastPosition = 0
            }
            lastMode = .Trending
            lastSearch = ""
            offset = lastPosition
        }
        
        let parameters = GifColl.RequestParameters(api_key: Helper.gifAPIKey, q: request.query, limit: Helper.numberOfGifs, offset: offset)
        
        let responseType = GifColl.GifDataRaw.self

        networkManager.makeWebRequest(url: url, parameters: parameters, responseType: responseType) {
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
