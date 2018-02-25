import Foundation
import SwiftyVK
import Just

final class APIWorker {

    private static let connectionUrl = "walkerapp.ru:8080"
    class func authorize( success: @escaping ([String : String]) -> ())
    {
        VK.sessions.default.logIn(
            onSuccess: success,
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
        }
        )
    }

    class func logout() {
        VK.sessions.default.logOut()
        print("SwiftyVK: LogOut")
    }
    
    class func getSmallEvents() -> [SmallEventDTO]{
        var output = [SmallEventDTO]()
        let responce = Just.get(connectionUrl)
        return output
    }
    
}

