import Foundation
import SwiftyVK
import Just
import ObjectMapper

final class APIWorker {

    private static let connectionUrl = "http://13.74.42.169:8080/"
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
    
    class func getMySmallEvents() -> [SmallEventDTO]
    {
        let responce = Just.get(connectionUrl+"events/get_profile_events", params:
            ["type":0,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<SmallEventsDTO>().map(JSONObject: responce.json)
        {
            return temp.eventsArray!
        }
        else {
            return [SmallEventDTO]()
        }
    }
    
    class func getUpcomingSmallEvents() -> [SmallEventDTO]{
        let responce = Just.get(connectionUrl+"events/get_profile_events", params:
            ["type":1,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<SmallEventsDTO>().map(JSONObject: responce.json)
        {
            return temp.eventsArray!
        }
        else {
            return [SmallEventDTO]()
        }
    }
    
    public class func getEventInfo(_ id: Int64) -> BigEventDTO
    {
        let responce = Just.get(connectionUrl+"events/get", params:
            ["event_id":id,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<BigEventDTO>().map(JSONObject: responce.json)
        {
            return temp
        }
        else {
            return BigEventDTO()
        }
    }
    
    private class func jsonToString(_ json: Any?) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8)
            return convertedString!
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
}

