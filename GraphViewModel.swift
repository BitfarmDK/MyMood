//
//  GraphViewModel.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 08/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

protocol GraphViewModelDelegate: class {
    func didProgress(with message: String, in viewModel: GraphViewModel)
    func didFinishUploadingEntries(to whenCastURL: URL?, in viewModel: GraphViewModel)
    func didEncounterError(with message: String, in viewModel: GraphViewModel)
}

class GraphViewModel {
    
    weak var delegate: GraphViewModelDelegate?

    var accessToken: String? {
        didSet {
            UserDefaults.standard.accessToken = self.accessToken
            
            guard self.accessToken != oldValue else { return }
            // Reset timestamp to upload all entries to new accessToken.
            UserDefaults.standard.lastUploadTimestamp = nil
        }
    }
    
    var counselorEmail: String? {
        didSet {
            UserDefaults.standard.counselorEmail = self.counselorEmail
        }
    }
    
    private var queuedEntries: [Entry] = []
    
    init() {
        self.accessToken = UserDefaults.standard.accessToken
        self.counselorEmail = UserDefaults.standard.counselorEmail
    }
    
    func load() {
        guard self.accessToken != nil else { return }
        // Check if schedule exists. Else create new schedule for MyMood. Add all new entries.
        if let scheduleId = UserDefaults.standard.currentWhenHubScheduleId {
            self.fetchSchedule(with: scheduleId)
        }
        else {
            self.createNewSchedule()
        }
    }
    
    private func createNewSchedule() {
        DispatchQueue.main.async {
            self.delegate?.didProgress(with: NSLocalizedString("Creating Schedule", comment: ""), in: self)
        }
        
        WhenHubBackend.shared.create() {
            switch $0 {
            case .success(let schedule):
                UserDefaults.standard.currentWhenHubScheduleId = schedule.id
                self.addNewEntries(to: schedule)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didEncounterError(with: NSLocalizedString("Error when creating new schedule: \(error)", comment: ""), in: self)
                }
            }
        }
    }
    
    private func fetchSchedule(with id: String) {
        DispatchQueue.main.async {
            self.delegate?.didProgress(with: NSLocalizedString("Fetching existing Schedule", comment: ""), in: self)
        }
        
        WhenHubBackend.shared.requestSchedule(with: id) {
            switch $0 {
            case .success(let schedule):
                UserDefaults.standard.currentWhenHubScheduleId = schedule.id
                self.addNewEntries(to: schedule)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didEncounterError(with: NSLocalizedString("Error when fetching existing schedule: \(error)", comment: ""), in: self)
                }
            }
        }
    }
    
    private func addNewEntries(to schedule: Schedule) {
        let lastTimestamp: Date? = UserDefaults.standard.lastUploadTimestamp
        
        // Find entries since.
        self.queuedEntries = {
            guard let timestamp = lastTimestamp else { return DummyDatabase.shared.entries.sorted(by: { $0.0.date < $0.1.date }) }
            return DummyDatabase.shared.entries.filter({ $0.date > timestamp }).sorted(by: { $0.0.date < $0.1.date })
        }()
        
        if self.queuedEntries.count > 0 {
            DispatchQueue.main.async {
                self.delegate?.didProgress(with: NSLocalizedString("Uploading entries: \(self.queuedEntries.count)", comment: ""), in: self)
            }
            let entry = self.queuedEntries.removeFirst()
            self.submit(entry: entry, to: schedule)
        }
        else {
            DispatchQueue.main.async {
                self.delegate?.didFinishUploadingEntries(to: schedule.whenCastChartUrl, in: self)
            }
        }
    }
    
    private func submit(entry: Entry, to schedule: Schedule) {
        WhenHubBackend.shared.create(entry: entry, in: schedule) {
            switch $0 {
            case .success():
                // Set timestamp for latest successfully uploaded Entry.
                UserDefaults.standard.lastUploadTimestamp = entry.date
                
                // Upload next or finish.
                if self.queuedEntries.count > 0 {
                    DispatchQueue.main.async {
                        self.delegate?.didProgress(with: NSLocalizedString("Uploading entries: \(self.queuedEntries.count)", comment: ""), in: self)
                    }
                    let entry = self.queuedEntries.removeFirst()
                    self.submit(entry: entry, to: schedule)
                }
                else {
                    print("did finish")
                    DispatchQueue.main.async {
                        self.delegate?.didFinishUploadingEntries(to: schedule.whenCastChartUrl, in: self)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didEncounterError(with: NSLocalizedString("Error when adding event: \(error)", comment: ""), in: self)
                }
            }
        }
    }
}
