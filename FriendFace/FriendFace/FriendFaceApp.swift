//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Eric Tolson on 11/21/22.
//

import SwiftUI

@main
struct FriendfaceApp: App {
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
