//
//  Schedule.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 08/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

/// All we use right now, is the id.
struct Schedule {
    
    let id: String
    let viewCode: String
    
    var whenCastChartUrl: URL? {
        return URL(string: "https://cdn.whenhub.com/v1/player/player.html?element-id=schedule&name=charts&schedule-id=\(self.id)&view-name=column&view-code=\(self.viewCode)")
    }
 
    init?(from json: [String: Any]) {
        guard let id = json["id"] as? String else { print("Schedule missing id"); return nil }
        self.id = id
        
        guard let viewCode = json["viewCode"] as? String else { print("Schedule missing viewCode"); return nil }
        self.viewCode = viewCode
    }
}
