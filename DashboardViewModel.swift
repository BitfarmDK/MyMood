//
//  DashboardViewModel.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

protocol DashboardViewModelDelegate: class {
    func didLoad(entries: [Entry], in viewModel: DashboardViewModel)
    func didAdd(entry: Entry, at index: Int, in viewModel: DashboardViewModel)
    func didRemove(entry: Entry, at index: Int, in viewModel: DashboardViewModel)
}

class DashboardViewModel {
    
    weak var delegate: DashboardViewModelDelegate?
    
    private(set) var entries: [Entry] = []

    init() {
        // Do something.
    }
    
    func refresh() {
        self.entries = DummyDatabase.shared.entries.reversed()
        self.delegate?.didLoad(entries: self.entries, in: self)
    }
}
