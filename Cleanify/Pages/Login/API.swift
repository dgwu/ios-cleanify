//
//  API.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 21/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation

//class API {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func doHttpPost(url: String, request: [String : Any]) {
        let parameterArray = request.map { (key, value) -> String in
            return "\(key)=\(value)"
        }
        var param:String = ""
        
        for str in parameterArray {
            param += str+"&"
        }
        
        if param.count > 0 {
            param.remove(at: param.index(before: param.endIndex))
        }

        let todosEndpoint: String = url+"?"+param
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            if let data = data, let resultString = String.init(data: data, encoding: String.Encoding.utf8) {
                print(resultString)
                let resDict = convertToDictionary(text: resultString)
                print(resDict)
            }
        }
        task.resume()
    }

    func doHttpGet(url: String) {
        let todosEndpoint: String = url
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            if let data = data, let resultString = String.init(data: data, encoding: String.Encoding.utf8) {
                //print(resultString)
                let resDict = convertToDictionary(text: resultString)
                print(resDict!)
            }
        }
        task.resume()
}

//}


