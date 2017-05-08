//
//  URLResponse+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 08/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

extension URLResponse {
    
    var httpStatusCode: Int {
        guard let response = self as? HTTPURLResponse else { return 999 }
        return response.statusCode
    }
}
