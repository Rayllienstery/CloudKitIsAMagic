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
    }

    // MARK: - Private
    private func configureNavigationController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "plus"), style: .plain,
                                                                 target: self, action: #selector(routeToAddNote))
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
