//
//  APIClient.swift
//  VoteSJSU
//
//  Created by Derek Lopes on 4/24/18.
//  Copyright © 2018 San Jose State University. All rights reserved.
//

import Foundation

class APIClient {
    static func get(endpoint: String, headers: [String : String]) -> (data: [[String: Any?]], rc: Int) {
        var rc: Int = -1
        var dataDict: [[String: Any?]] = [[:]]
        var urlString = "http://" + Constants.BACKEND_URL + endpoint + "?"
        for key in headers.keys {
            urlString += key + "=" + headers[key]! + "&"
        }
        print("Calling GET on", urlString)
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for networking error
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            // verify response code
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            rc = (response as! HTTPURLResponse).statusCode
            
            // get response data
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            do {
                dataDict = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as! [[String : AnyObject]]
                print("Data returned:", dataDict)
            } catch {
                print("No data returned:", error.localizedDescription)
            }
        }
        task.resume()
        
        while task.state != URLSessionTask.State(rawValue: 3) {
            // wait for call to complete
            sleep(1)
        }
        
        return (dataDict, rc)
    }
    
    static func post(endpoint: String, body: [String : String]) -> (data: Any?, rc: Int) {
        var dataDict: Any?
        var rc = -1
        let urlString = "http://" + Constants.BACKEND_URL + endpoint
        print("Calling POST on", urlString)
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return (nil, rc)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for networking error
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            // verify response code
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            rc = (response as! HTTPURLResponse).statusCode
            
            // get response data
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            do {
                dataDict = try JSONSerialization.jsonObject(with: data, options: [])
                print("Data returned:", dataDict!)
            } catch {
                print("No data returned:", error.localizedDescription)
            }
        }
        task.resume()
        
        while task.state != URLSessionTask.State(rawValue: 3) {
            // wait for call to complete
            sleep(1)
        }
        
        return (dataDict, rc)
    }
    
    static func delete(endpoint: String, headers: [String : String]) -> Int {
        var rc: Int = -1
        var urlString = "http://" + Constants.BACKEND_URL + endpoint + "?"
        for key in headers.keys {
            urlString += key + "=" + headers[key]! + "&"
        }
        print("Calling DELETE on", urlString)
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for networking error
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            // verify response code
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                print("statusCode should be 204, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            rc = (response as! HTTPURLResponse).statusCode
            
            // get response data
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
        while task.state != URLSessionTask.State(rawValue: 3) {
            // wait for call to complete
            sleep(1)
        }
        
        return rc
    }
}
