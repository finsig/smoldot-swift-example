//
//  SmoldotSwiftExampleApp.swift
//  SmoldotSwiftExample
//
//  Created by Steven Boynes on 6/27/24.
//

import SwiftUI

@main
struct SmoldotSwiftExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ChainListView()
                .preferredColorScheme(.dark)
        }
    }
}
