//
//  DetailViewController.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate: class {

}

class DetailViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
    let entry: Entry

    init(entry: Entry) {
        self.entry = entry
    }
}
