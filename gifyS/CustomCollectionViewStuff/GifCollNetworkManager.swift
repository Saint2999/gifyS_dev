import Alamofire

final class GifCollNetworkManager {
    
    func makeWebRequest<S: Encodable, T: Decodable>(url: String, parameters: S, responseType: T.Type, completion: @escaping (_ repsonse: T?, _ error: AFError?) -> Void) {
        AF.request(url, parameters: parameters).validate().responseDecodable(of: responseType) {
            response in
            debugPrint(response.value as Any)
            switch response.result {
            case .success(let gifs):
                completion(gifs, nil)
            
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
}
