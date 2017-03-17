import Foundation
import Alamofire

open class SeedClient {
    fileprivate let baseUrl: String

    public init(baseUrl : String) {
        self.baseUrl = baseUrl
    }

    open func getSeeds(_ callback: @escaping (String) -> () ) {
        Alamofire.request("\(baseUrl)/seeds")
            .responseJSON { (response) in
                if let jsonResult = response.result.value as? Dictionary<String, AnyObject> {
                    if let result = jsonResult["seeds"] as? String {
                        callback(result)
                    }
                    if let result = jsonResult["error"] as? String {
                        callback(result)
                    }
                }
        }
    }
}
