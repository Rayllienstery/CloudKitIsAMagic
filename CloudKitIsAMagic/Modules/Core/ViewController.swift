//
//  ViewController.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 04.06.2024.
//

import UIKit
import SwiftUI

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationController()
        self.configureScreen()
    }

    // MARK: - Private
    private func configureNavigationController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "plus"), style: .plain,
                                                                 target: self, action: #selector(routeToAddNote))
    }

    private func configureScreen() {
        let swiftUIView = UIHostingController(rootView: DashboardView()
            .environment(\.managedObjectContext, .current)
            .modelContainer(.current))
        swiftUIView.tabBarItem.image = .init(systemName: "swift")
        swiftUIView.tabBarItem.title = "SwiftUI"

        let uiKitController = DashboardViewController(style: .insetGrouped)
        uiKitController.tabBarItem.image = .init(systemName: "mosaic.fill")
        uiKitController.tabBarItem.title = "UIKit"

        self.viewControllers = [ swiftUIView, uiKitController ]
    }

    // MARK: - Actions
    @objc private func routeToAddNote() {
        let view = NoteEditorView()
            .environment(\.managedObjectContext, .current)
            .modelContainer(.current)
        present(UIHostingController(rootView: view), animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: ViewController())
}
