import Foundation
import SwiftyVK
import Just
import ObjectMapper
import Alamofire
import Alamofire_Synchronous
import UIKit
final class APIWorker {
    
    private static let connectionUrl = "http://188.134.92.52:1725/"
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
    
    class func getMySmallEvents(completion: @escaping ([SmallEventDTO]?) -> Void)
    {
        let responce = Just.get(connectionUrl+"events/get_profile_events", params:
            ["type":0,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<SmallEventsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.eventsArray)
        }
        else{
            completion(nil)
        }
    }
    
    class func getUpcomingSmallEvents(completion: @escaping ([SmallEventDTO]?) -> Void)
    {
        let responce = Just.get(connectionUrl+"events/get_profile_events", params:
            ["type":1,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<SmallEventsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.eventsArray)
        }
        else {
            completion(nil)
        }
    }
    
    class func getPastSmallEvents(completion: @escaping ([SmallEventDTO]?) -> Void)
    {
        let responce = Just.get(connectionUrl+"events/get_profile_events", params:
            ["type":2,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<SmallEventsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.eventsArray)
        }
        else {
            completion(nil)
        }
    }
    
    public class func getEventInfo(_ id: Int64, completion: @escaping (BigEventDTO?) -> Void)
    {
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType) == "" || UserDefaults.standard.string(forKey: defaultsKeys.authType) == nil)
        {
            completion(nil)
        }
        let responce = Just.get(connectionUrl+"events/get", params:
            ["event_id":id,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<BigEventDTO>().map(JSONObject: responce.json)
        {
            completion(temp)
        }
        else {
            completion(nil)
        }
    }
    
    public class func getEventInfoSync(_ id: Int64) -> BigEventDTO?
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
            return nil
        }
    }
    public class func getEventParticipants(_ id : Int64, completion: @escaping ([LoginDTO]?) -> Void)
    {
        let responce = Just.get(connectionUrl+"events/get_participants", params:
            ["event_id":id,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        
        if let temp = Mapper<LoginsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.loginsArray)
        }
        else
        {
            completion(nil)
        }
    }
    
    public class func getMapEvents(minLat: Double,minLon: Double, maxLat:Double, maxLon: Double, completion: @escaping ([MapEventDTO]?) -> Void)
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
                completion(temp.eventsList)
            }
            else
            {
                completion(nil)
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
                completion(temp.eventsList)
            }
            else
            {
                completion(nil)
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
    
    public class func addEvent(_ event : NewEventDTO, completion: @escaping (Int64?) -> Void)
    {
        event.groupId = 0
        let jsonstring = event.toJSON()
        let url = connectionUrl + "events/new"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        let response = Alamofire.request(url, method: .post, parameters: jsonstring, encoding: JSONEncoding.default, headers: headers).responseJSON()
        
        if let json = (response.result.value as! Int64?){
            completion(json)
        }
        return completion(-1)
    }
    
    public class func changeEvent(_ event: ChangeEventDTO) -> Bool
    {
        let jsonstring = event.toJSON()
        let url = connectionUrl + "events/change"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        let response = Alamofire.request(url, method: .post, parameters: jsonstring, encoding: JSONEncoding.default, headers: headers).responseJSON()
        
        if let json = response.result.value {
            return json as! Bool
        }
        
        return false
    }
    
    public class func deleteEvent(_ eventId: Int64, completion: @escaping (Bool) -> Void){
        let responce = Just.get(connectionUrl+"events/delete", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "event_id": eventId
            ])
        if(responce.ok)
        {
            completion(responce.text!.compare("true").rawValue == 0)
        }
        else
        {
            completion(false)
        }
    }
    
    public class func getMyGroups(completion: @escaping ([SmallGroupDTO]?) -> Void){
        let responce = Just.get(connectionUrl+"/groups/get_own", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
            ])
        if let temp = Mapper<SmallGroupsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.groupsArray)
        }
        else{
            completion(nil)
        }
    }
    
    public class func searchGroups(query: String, offset: Int, quantity: Int, completion: @escaping ([SmallGroupDTO]?) -> Void){
        let responce = Just.get(connectionUrl+"/groups/search", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "key_word": query,
                "offset": offset,
                "quantity": quantity
                ])
        if let temp = Mapper<SmallGroupsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.groupsArray)
        }
        else{
            completion(nil)
        }
    }
    
    public class func participateInGroup(groupId: Int64, completion: @escaping (Bool?) -> Void){
        let responce = Just.get(connectionUrl+"/groups/new_participant", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "group_id": groupId
            ])
        if(responce.ok)
        {
            completion(responce.text!.compare("true").rawValue == 0)
        }
        else
        {
            completion(false)
        }
    }
    
    public class func leaveGroup(groupId: Int64, completion: @escaping (Bool?) -> Void){
        let responce = Just.get(connectionUrl+"/groups/delete_participant", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "participant_id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "group_id": groupId
            ])
        if(responce.ok)
        {
            completion(responce.text!.compare("true").rawValue == 0)
        }
        else
        {
            completion(false)
        }
    }
    
    public class func getGroupInfo(groupId: Int64, completion: @escaping (GroupDTO?) -> Void){
        let responce = Just.get(connectionUrl+"/groups/get", params:
            [
                "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
                "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                "group_id": groupId
            ])
        if let temp = Mapper<GroupDTO>().map(JSONObject: responce.json)
        {
            completion(temp)
        }
        else{
            completion(nil)
        }
    }
    
    public class func getGroupParticipants(groupId: Int64, completion: @escaping ([LoginDTO]?) -> Void){
        let responce = Just.get(connectionUrl+"groups/get_participants", params:
            ["group_id":groupId,
             "id": Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!)!,
             "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!
            ])
        if let temp = Mapper<LoginsDTO>().map(JSONObject: responce.json)
        {
            completion(temp.loginsArray)
        }
        else
        {
            completion(nil)
        }
    }
    
    private func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
}

