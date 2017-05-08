//
//  EntryFormViewModel.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

protocol EntryFormViewModelDelegate: class {

}

class EntryFormViewModel {
    
    weak var delegate: EntryFormViewModelDelegate?

    init() {
        
    }
    
    func save(entry: Entry) {
        DummyDatabase.shared.add(entry)
    }
}
