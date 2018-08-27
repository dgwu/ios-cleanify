//
//  CleanifyApi.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 23/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation

class CleanifyApi {
//    let baseURL = "http://localhost:8080/api"
    let baseURL = "https://cleanify.danielgunawan.com/api"
    
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
                    print("Error on requestAndCheckIsValid: \(error.localizedDescription)")
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
                    print("Error on postAndCheckIsValid: \(error.localizedDescription)")
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
                        return
                    } else {
                        print("gagal translate events")
                    }
                } catch {
                    print("Error on fetchEventList: \(error.localizedDescription)")
                }
            }
            completion(nil)
        }
    }
    
    func fetchNewsList(completion: @escaping([CleanifyNew]?) -> Void) {
        let apiPath = "latestnews"
        
        requestAndCheckIsValid(apiPath: apiPath) { (responseDictionary) in
            if let responseDictionary = responseDictionary {
                do {
                    if let events = responseDictionary["news"] as? [[String : Any]] {
                        // turn dictionary into data JsonDataObject
                        let jsonData = try JSONSerialization.data(withJSONObject: events, options: JSONSerialization.WritingOptions.sortedKeys)
                        
                        // decode the JsonDataObject into desired object using Decodable
                        let cleanifyNews = try JSONDecoder().decode([CleanifyNew].self, from: jsonData)
                        completion(cleanifyNews)
                        return
                    } else {
                        print("gagal translate events")
                    }
                } catch {
                    print("Error on fetchEventList: \(error.localizedDescription)")
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
    
    func fetchReportList(completion: @escaping([CleanifyReport]?) -> Void) {
        let apiPath = "latestreports"
        
        requestAndCheckIsValid(apiPath: apiPath) { (responseDictionary) in
            if let responseDictionary = responseDictionary {
                do {
                    if let reports = responseDictionary["reports"] as? [[String : Any]] {
                        // turn dictionary into data JsonDataObject
                        let jsonData = try JSONSerialization.data(withJSONObject: reports, options: JSONSerialization.WritingOptions.sortedKeys)
                        
                        // decode the JsonDataObject into desired object using Decodable
                        let cleanifyReports = try JSONDecoder().decode([CleanifyReport].self, from: jsonData)
                        completion(cleanifyReports)
                        return
                    } else {
                        print("gagal translate reports")
                    }
                } catch {
                    print("Error on fetchReportList: \(error.localizedDescription)")
                }
            }
            
            completion(nil)
        }
    }
}
