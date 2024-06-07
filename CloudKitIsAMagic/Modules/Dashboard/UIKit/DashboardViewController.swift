//
//  DashboardViewController.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 05.06.2024.
//

import SwiftUI
import SwiftData

class DashboardViewController: UITableViewController {
    var swiftDataNotes: [SwiftDataNote] = []
    var coreDataNotes: [CoreDataNote] = []

    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchData()
        self.initDataFlow()
    }

    private func initDataFlow() {
        NotificationCenter.default.addObserver(forName: .dataFlowUpdated, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            fetchData()
        }
    }

    private func fetchData() {
        Task {
            do {
                let swiftDataContext = PersistenceController.shared.sdContainer.mainContext
                self.swiftDataNotes = try swiftDataContext.fetch(FetchDescriptor<SwiftDataNote>())
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        Task {
            do {
                let coreDataContext = PersistenceController.shared.cdContext
                self.coreDataNotes = try coreDataContext.fetch(CoreDataNote.fetchRequest())
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

#Preview {
    UINavigationController(rootViewController: ViewController())
}
