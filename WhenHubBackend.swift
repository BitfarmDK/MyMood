//
//  WhenHubBackend.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

struct WhenHubBackend {
    
    static let shared = WhenHubBackend()
    
    let baseUrl = URL(string: "https://api.whenhub.com/api")!

    let moodFieldId = "MyMoodChartSeries"
    
    func create(completion: @escaping (Result<Schedule>) -> Void) {
        
        // TODO: Implement more custom fields (Emotion, Activity) and media.
        
        let defaultSchedule: [String: Any] = [
            "calendar": [
                "calendarType": "absolute"
            ],
            "name": "MyMood Journal",
            "description": "A therapeutic journal",
            "curator": "MyMood app",
            "scope": "private",
            "sync": false,
            "customFields": [
                [
                    "id": self.moodFieldId,
                    "customField": "chart-series",
                    "name": "Chart Series",
                    "config": [
                        "fieldName": "mood"
                    ]
                ]
            ]
        ]
        
        print("defaultSchedule: \(defaultSchedule)")
        
        // Create request.
        let url = self.baseUrl.appendingPathComponent("users").appendingPathComponent("me").appendingPathComponent("schedules")
        var request = URLRequest(method: .post, url: url)
        
        // Parse JSON body.
        guard let jsonData = try? JSONSerialization.data(withJSONObject: defaultSchedule, options: []) else { completion(.failure(.invalidRequestJSON)); return }
        request.httpBody = jsonData
        
        // Execute.
        URLSession.shared.executeJSONDataTask(with: request) {
            switch $0 {
            case .success(let json):
                guard let schedule = Schedule(from: json) else { completion(.failure(.invalidResponseJSON)); return }
                completion(.success(schedule))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func create(entry: Entry, in schedule: Schedule, completion: @escaping (Result<Void>) -> Void) {
        
        // Create request.
        let url = self.baseUrl.appendingPathComponent("schedules").appendingPathComponent(schedule.id).appendingPathComponent("events")
        var request = URLRequest(method: .post, url: url)
        
        // Parse JSON body.
        guard let jsonData = try? JSONSerialization.data(withJSONObject: entry.dictionary, options: []) else { completion(.failure(.invalidRequestJSON)); return }
        request.httpBody = jsonData
        
        // Execute.
        URLSession.shared.executeJSONDataTask(with: request) {
            switch $0 {
            case .success(_):
                completion(.success())
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestSchedule(with id: String, completion: @escaping (Result<Schedule>) -> Void) {
        print("requestSchedule with id: \(id)")
        
        // Create request.
        let url = self.baseUrl.appendingPathComponent("schedules").appendingPathComponent(id)
        let request = URLRequest(method: .get, url: url)
        
        // Execute.
        URLSession.shared.executeJSONDataTask(with: request) {
            switch $0 {
            case .success(let json):
                guard let schedule = Schedule(from: json) else { completion(.failure(.invalidResponseJSON)); return }
                completion(.success(schedule))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
