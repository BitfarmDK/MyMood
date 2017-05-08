//
//  Result.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(AppError)
}
