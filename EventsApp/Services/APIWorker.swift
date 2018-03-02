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
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType) == "" || UserDefaults.standard.string(forKey: defaultsKeys.authType) == nil)
        {
            return [SmallEventDTO]()
        }
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
    
    class func getPastSmallEvents() -> [SmallEventDTO]{
        let responce = Just.get(connectionUrl+"events/get_profile_events", params:
            ["type":2,
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
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType) == "" || UserDefaults.standard.string(forKey: defaultsKeys.authType) == nil)
        {
            return BigEventDTO()
        }
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
    public class func getEventParticipants(_ id : Int64) -> [LoginDTO]
    {
        let responce = Just.get(connectionUrl+"events/get_participants", params:
            ["event_id":id,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        
        if let temp = Mapper<LoginsDTO>().map(JSONObject: responce.json)
        {
            return temp.loginsArray!
        }
        else
        {
            return [LoginDTO]()
        }
    }
    
    public class func getMapEvents(minLat: Double,minLon: Double, maxLat:Double, maxLon: Double) -> [MapEventDTO]
    {
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType) == "" || UserDefaults.standard.string(forKey: defaultsKeys.authType) == nil)
        {
            let responce = Just.get(connectionUrl+"events/get_between_public", params:
                [
                    "min_lat":minLat,
                    "max_lat":maxLat,
                    "min_lon":minLon,
                    "max_lon":maxLon,
                    ])
            if let temp = Mapper<MapEventsDTO>().map(JSONObject: responce.json)
            {
                return temp.eventsList!
            }
            else
            {
                return [MapEventDTO]()
            }
        }
        else
        {
            let responce = Just.get(connectionUrl+"events/get_between", params:
                [
                    "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                    "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                    "min_lat":minLat,
                    "max_lat":maxLat,
                    "min_lon":minLon,
                    "max_lon":maxLon,
                    ])
            if let temp = Mapper<MapEventsDTO>().map(JSONObject: responce.json)
            {
                return temp.eventsList!
            }
            else
            {
                return [MapEventDTO]()
            }
        }
    }
    
    public class func participateInEvent(_ eventId: Int64)-> Bool
    {
        let responce = Just.get(connectionUrl+"events/new_participant", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "event_id": eventId
                ])
        if(responce.ok)
        {
            return responce.text!.compare("true").rawValue == 0
        }
        else
        {
            return false
        }
        
    }
    public class func deleteParticipantOfEvent(_ eventId: Int64)-> Bool
    {
        let responce = Just.get(connectionUrl+"events/delete_participant", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "participant_id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "event_id": eventId
            ])
        if(responce.ok)
        {
            return responce.text!.compare("true").rawValue == 0
        }
        else
        {
            return false
        }
    }
}

