//
//  API.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 21/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation
import UIKit

//class API {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

func doHttpPost(url: String, request: [String : Any], completion: @escaping (_ result: [String : Any]) -> Void) {
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
    
    let request = NSMutableURLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.httpBody = param.data(using: String.Encoding.utf8)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        if let data = data, let resultString = String.init(data: data, encoding: String.Encoding.utf8) {
            completion(convertToDictionary(text: resultString)!)
        }
    })
    task.resume()
}

func doLogin(url: String, request: [String : Any], vc: UIViewController) {
    print("do login")
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
    
    let request = NSMutableURLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.httpBody = param.data(using: String.Encoding.utf8)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        if let data = data, let resultString = String.init(data: data, encoding: String.Encoding.utf8) {
            let data = convertToDictionary(text: resultString)!
            if data["isValid"] as! Bool == true {
                print("is valid")
                UserDefaults.standard.set(data["user_token"] as! String, forKey: USER_TOKEN)
                UserDefaults.standard.synchronize();
                let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController
                vc?.navigationController?.present(vc!, animated: true)
            }
        }
    })
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
                let resDict = convertToDictionary(text: resultString)
                print(resDict!)
            }
        }
        task.resume()
}

//}


