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
                    callback(jsonResult["seeds"] as! String)
                }
        }
    }
}
