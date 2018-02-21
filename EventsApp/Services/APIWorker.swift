import Foundation
import SwiftyVK


final class APIWorker {

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
    
    
}

