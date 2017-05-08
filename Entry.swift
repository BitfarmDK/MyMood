//
//  ReportItem.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

struct Entry {
    let mood: Int
    let date: Date
    let emotion: String?
    let location: String?
    let activity: String?
    let photos: [URL]
    let audio: [URL]
    let videos: [URL]
    
    var moodText: String {
        return "\(self.mood)"
    }
    
    var dateText: String {
       return Formatters.reportTimestamp.string(from: self.date)
    }
    
    var textSnippet: String {
        if let emotion: String = self.emotion?.trimmingCharacters(in: .whitespacesAndNewlines), !emotion.isEmpty {
            return emotion
        }
        if let location: String = self.location?.trimmingCharacters(in: .whitespacesAndNewlines), !location.isEmpty {
            return location
        }
        if let activity: String = self.activity?.trimmingCharacters(in: .whitespacesAndNewlines), !activity.isEmpty {
            return activity
        }
        return NSLocalizedString("No extra information", comment: "")
    }
    
    /// Computed variable that returns a JSON representation of this Entry.
    var dictionary: [String: Any] {
        var json: [String: Any] = [:]
        
        // Add timestamp.
        json["when"] = [
            "period": "minute",
            "startDate": Formatters.iso8601Formatter.string(from: self.date)
        ]
        
        // Add name.
        json["name"] = self.textSnippet
        
        // Add mood score.
        json["customFieldData"] = [
            WhenHubBackend.shared.moodFieldId: [
                "value": self.mood
            ]
        ]
        
        // Add optional location.
        if let location = self.location {
            json["location"] = [
                "name": location
            ]
        }
        
        // TODO: Add custom fields for emotion and activity?
        
        // TODO: Add media?
        
        return json
    }
}
