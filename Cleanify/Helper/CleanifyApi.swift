//
//  CleanifyApi.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 23/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation

class CleanifyApi {
    let baseURL = "http://localhost:8080/api"
//    let baseURL = "https://cleanify.danielgunawan.com/api"
    
    func requestAndCheckIsValid(apiPath: String, completion: @escaping([String:Any]?) -> Void) {
        let requestUrl = URL(string: "\(self.baseURL)/\(apiPath)")!
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if let data = data {
                do {
                    if let responseDictionary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let isValid = responseDictionary["isValid"] as? Bool, isValid {
                            completion(responseDictionary)
                            return
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(nil)
        }
        task.resume()
    }
    
    func postAndCheckIsValid(apiPath: String, parameters: [String: Any], completion: @escaping([String:Any]?) -> Void) {
        let requestURL = URL(string: "\(self.baseURL)/\(apiPath)")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.sortedKeys)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let responseDictionary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let isValid = responseDictionary["isValid"] as? Bool, isValid {
                            completion(responseDictionary)
                            return
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(nil)
        }
        task.resume()
    }
    
    func fetchEventList(completion: @escaping([CleanifyEvent]?) -> Void) {
        let apiPath = "ongoingevents"
        
        requestAndCheckIsValid(apiPath: apiPath) { (responseDictionary) in
            if let responseDictionary = responseDictionary {
                do {
                    if let events = responseDictionary["events"] as? [[String : Any]] {
                        // turn dictionary into data JsonDataObject
                        let jsonData = try JSONSerialization.data(withJSONObject: events, options: JSONSerialization.WritingOptions.sortedKeys)
                        
                        // decode the JsonDataObject into desired object using Decodable
                        let cleanifyEvents = try JSONDecoder().decode([CleanifyEvent].self, from: jsonData)
                        completion(cleanifyEvents)
                    } else {
                        print("gagal translate events")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            completion(nil)
        }
    }
    
    func participateEvent(eventId: Int, userToken: String, completion: @escaping(Bool) -> Void) {
        let apiPath = "participateevent"
        let parameters: [String: Any] = [
            "event_id" : eventId,
            "api_token" : userToken
        ]
        
        postAndCheckIsValid(apiPath: apiPath, parameters: parameters) { (responseDictionary) in
            completion(true)
        }
    }
}
