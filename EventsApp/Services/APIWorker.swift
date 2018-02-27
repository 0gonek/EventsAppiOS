import Foundation
import SwiftyVK
import Just
import ObjectMapper

final class APIWorker {

    private static let connectionUrl = "walkerapp.ru:8080"
    class func authorize( success: @escaping ([String : String]) -> (), onError: @escaping (VKError) -> ())
    {
        VK.sessions.default.logIn(
            onSuccess: success,
            onError: onError
        )
    }

    class func logout() {
        VK.sessions.default.logOut()
        print("SwiftyVK: LogOut")
    }
    class func silentLogin() -> Bool
    {
        return (vkDelegateReference as! VKDelegate).silentLogin()
    }
    
    class func getSmallEvents() -> [SmallEventDTO]{
        var output = [SmallEventDTO]()
        let temp = Mapper().toJSONString(SmallEventDTO());
        let kek = Mapper<SmallEventDTO>().map(JSONString: temp!)
        //let responce = Just.get(connectionUrl)
        output.append(kek!)
        return output
    }
    
}

