//
//  AppError.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 08/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

enum AppError {
    case invalidRequestJSON
    case noResponse
    case status(status: Int, body: Data?)
    case noContent
    case invalidResponseJSON
    case unknown(Error)
}
