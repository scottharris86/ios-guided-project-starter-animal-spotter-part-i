//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    var bearer: Bearer?
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        // create endpoint-specific URL
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        // create url request from above
        var request = URLRequest(url: signUpURL)
        
        // modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode user model to JSON, attach as request body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
        } catch {
            NSLog("Error encoding user object \(error)")
            completion(error)
            return
        }
        
        // set up data task and handle response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            // if we get this far, the response contained no errors, so sign up was successful
            completion(nil)
            
        }.resume()
        
        
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        // create endpoint-specific URL
        let signInURL = baseUrl.appendingPathComponent("users/login")
        
        // create url request from above
        var request = URLRequest(url: signInURL)
        
        // modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode user model to JSON, attach as request body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
        } catch {
            NSLog("Error encoding user object \(error)")
            completion(error)
            return
        }
        
        // set up data task and handle response
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            do {
                let decoder = JSONDecoder()
                self.bearer = try decoder.decode(Bearer.self, from: data)
                
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            // if we get this far, the response contained no errors, so Log in was successful
            completion(nil)
            
        }.resume()
        
        
    }
    
    // create function for fetching all animal names
    
    // create function to fetch image
}
