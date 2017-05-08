//
//  URLRequest+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 08/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

extension URLRequest {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    init(method: HttpMethod, url: URL) {
        self.init(url: url)
        self.httpMethod = method.rawValue
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Load WhenHub access token from UserDefaults.
        if let token = UserDefaults.standard.accessToken {
            self.addValue(token, forHTTPHeaderField: "Authorization")
        }
    }
}

