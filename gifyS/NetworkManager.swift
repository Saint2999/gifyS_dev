import Alamofire

final class NetworkManager {
    
    private init() {}
    
    class func makeWebRequest<S: Encodable, T: Decodable>(url: String, method: HTTPMethod, parameters: S, responseType: T.Type, completion: @escaping (_ repsonse: T?, _ error: AFError?) -> Void) {
        AF.request(url, method: method, parameters: parameters).validate().responseDecodable(of: responseType) {
            response in
            debugPrint(response)
            switch response.result {
            case .success(let gifs):
                completion(gifs, nil)
            
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
}
