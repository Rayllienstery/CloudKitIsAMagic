//
//  DashboardViewController+TableView.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 07.06.2024.
//

import UIKit

extension DashboardViewController {
    override func numberOfSections(in tableView: UITableView) -> Int { DashboardSections.allCases.count }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = DashboardSections(rawValue: section) else { fatalError() }
        switch section {
        case .swiftData: return "SwiftData"
        case .coreData: return "CoreData"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DashboardSections(rawValue: section) else { fatalError() }
        switch section {
        case .swiftData: return swiftDataNotes.count
        case .coreData: return coreDataNotes.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        guard let section = DashboardSections(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .swiftData:
            cell.textLabel?.text = swiftDataNotes[indexPath.row].title
            cell.imageView?.image = .init(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            cell.imageView?.tintColor = NoteColor(rawValue: swiftDataNotes[indexPath.row].colorIndex)!.colorRepresentation
        case .coreData:
            cell.textLabel?.text = coreDataNotes[indexPath.row].title
            cell.imageView?.image = .init(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            cell.imageView?.tintColor = NoteColor(rawValue: Int(coreDataNotes[indexPath.row].colorIndex))!.colorRepresentation
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self else { return }
            guard let section = DashboardSections(rawValue: indexPath.section) else { fatalError() }
            let offset = indexPath.row
            
            switch section {
            case .swiftData:
                Task {
                    do {
                        let swiftDataContext = PersistenceController.shared.sdContainer.mainContext
                        swiftDataContext.delete(self.swiftDataNotes[offset])
                        try swiftDataContext.save()
                        self.swiftDataNotes.remove(at: offset)
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            case .coreData:
                do {
                    let coreDataContext = PersistenceController.shared.cdContext
                    coreDataContext.delete(self.coreDataNotes[offset])
                    try coreDataContext.save()
                    self.coreDataNotes.remove(at: offset)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }

        return .init(actions: [deleteAction])
    }
}

private enum DashboardSections: Int, CaseIterable {
    case swiftData, coreData
}
