//
//  CleanifyApi.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 23/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation
import UIKit

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
    
    func requestAndCheckIsValidWithQueries(apiPath: String, queries: [String:String]?, completion: @escaping([String:Any]?) -> Void) {
        let baseURL = URL(string: "\(self.baseURL)/\(apiPath)")!
        var requestUrl = baseURL
        
        if let queries = queries, queries.count > 0 {
            requestUrl = baseURL.withQueries(queries)!
        }
        
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
    
    func fetchEventListWithUser(completion: @escaping([CleanifyEvent]?) -> Void) {
        let apiPath = "ongoingevents"
        
        let queries = [
            "api_token" : getUserToken()
        ]
        
        requestAndCheckIsValidWithQueries(apiPath: apiPath, queries: queries) { (responseDictionary) in
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
    
    //Generate boundary
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    //create body
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data?, boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        if imageDataKey != nil {
            let filename = "user-profile.jpg"
            let mimetype = "image/jpg"
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
            body.append(imageDataKey! as Data)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        return body as Data
    }
    
    //create session
    func postReportWithPhoto(photo : UIImage? , apiPath: String, parameters: [String:String], completionClosure: @escaping(String?) -> Void)  {
        let requestURL = URL(string: "\(self.baseURL)/\(apiPath)")!
        var urlSession : URLSession!
        
        urlSession = URLSession(configuration: .default)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let photo = photo else {
            request.httpBody = createBodyWithParameters(parameters: parameters, filePathKey: "photo", imageDataKey: nil, boundary: boundary)
            
            let postDataTask = urlSession.dataTask(with: request, completionHandler: {(data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    print(String.init(data: data, encoding: .utf8))
                    if let jsonResult: NSDictionary  = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
                        print(jsonResult)
                    } else {
                        print("empty")
                    }
                } else {
                    print("empty")
                }
            })
            postDataTask.resume()
            
            return
        }
        
        let imageData = UIImageJPEGRepresentation(photo, 0.3)
        request.httpBody = createBodyWithParameters(parameters: parameters, filePathKey: "photo", imageDataKey: imageData, boundary: boundary)
        let postDataTask = urlSession.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                if let jsonResult: NSDictionary  = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
                    print(jsonResult)
                } else {
                    print("empty")
                }
            } else {
                print("empty")
            }
        })
         completionClosure("SELESAI")
        postDataTask.resume()
    }
    
    func postAnReport(completion: @escaping(String?) -> Void) {
        let apiPath = "postreport"
        let parameters: [String: String] = [
            "api_token" : "sejok",
            "title":"Thanks God, its works",
            "body":"lorem ipsumz",
            "location_desc":"bsd",
            "location_longitude":"106.642002",
            "location_latitude":"-6.3017287",
            ]
        
        postReportWithPhoto(photo: UIImage.init(named: "sample_img"), apiPath: apiPath, parameters: parameters) { (_) in
            print("postAnReport done")
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
