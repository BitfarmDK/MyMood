//
//  URLSession+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

extension URLSession {
    
    /// Expects a result with a JSON body for status < 400 (except 204). Calls URLSessionDataTask.resume()!
    func executeJSONDataTask(with request: URLRequest, completion: @escaping (Result<[String: Any]>) -> Void) {
        self.dataTask(with: request) { data, response, error in
            #if DEBUG
                let httpMethod = request.httpMethod ?? "NO_METHOD"
                let url = request.url?.absoluteString ?? "NO_URL"
                print("\(httpMethod) \(url) - \(response?.httpStatusCode ?? 0)")
            #endif
            if let error = error { completion(.failure(AppError.unknown(error))); return }
            guard let response = response else { completion(.failure(AppError.noResponse)); return }
            let status = response.httpStatusCode
            guard status < 400 else { completion(.failure(AppError.status(status: status, body: data))); return }
            guard status != 204 else { completion(.success([:])); return } // Missing body is valid for status 204.
            guard let data = data else { completion(.failure(AppError.noContent)); return }
            guard let parsedObject = try? JSONSerialization.jsonObject(with: data), let json = parsedObject as? [String: Any] else { completion(.failure(AppError.invalidResponseJSON)); return }
            completion(.success(json))
            }.resume()
    }
}
