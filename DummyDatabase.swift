//
//  DummyDatabase.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

class DummyDatabase {
    
    static let shared = DummyDatabase()
    
    private(set) var entries: [Entry] = []
    
    init() {
        self.entries = {
            guard let dummyContent: Data = UserDefaults.standard.dummyDatabaseContent else { print("No saved content"); return [] }
            guard let json = try? JSONSerialization.jsonObject(with: dummyContent, options: []), let jsonList = json as? [[String: Any]] else { print("Failed to parse saved JSON content"); return [] }
            return jsonList.flatMap({ self.deserializeEntry(from: $0) })
        }()
    }
    
    func add(_ entry: Entry) {
        self.entries.append(entry)
        
        DispatchQueue(label: "Background").async {
            let jsonList = self.entries.map { self.serialize(entry: $0) }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonList, options: []) else { print("Failed to save content as JSON"); return }
            UserDefaults.standard.dummyDatabaseContent = jsonData
        }
    }
    
    private func serialize(entry: Entry) -> [String: Any] {
        var json: [String: Any] = [:]
        json["mood"] = entry.mood
        json["date"] = Formatters.iso8601Formatter.string(from: entry.date)
        
        if let value = entry.emotion {
            json["emotion"] = value
        }
        
        if let value = entry.location {
            json["location"] = value
        }
        
        if let value = entry.activity {
            json["activity"] = value
        }
        
        // Ignore media for now...
        return json
    }
    
    private func deserializeEntry(from json: [String: Any]) -> Entry? {
        guard let mood = json["mood"] as? Int else { return nil }
        guard let dateString = json["date"] as? String, let date = Formatters.iso8601Formatter.date(from: dateString) else { return nil }
        
        return Entry(
            mood: mood,
            date: date,
            emotion: json["emotion"] as? String,
            location: json["location"] as? String,
            activity: json["activity"] as? String,
            photos: [],
            audio: [],
            videos: []
        )
        // Ignore media for now...
    }
}
