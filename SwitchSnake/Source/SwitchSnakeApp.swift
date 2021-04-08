//
//  SwitchSnakeApp.swift
//  SwitchSnake
//
//  Created by Mike Price on 07.04.2021.
//

import SwiftUI
import AppKit

@main
struct SwitchSnakeApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate

	var body: some Scene {
		WindowGroup {
			RootView()
				.onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
					NSApplication.shared.windows.forEach { $0.tabbingMode = .disallowed }
				}
		}
		.commands {
			CommandGroup(replacing: CommandGroupPlacement.newItem) {}
			CommandGroup(replacing: CommandGroupPlacement.undoRedo) {}
			CommandGroup(replacing: CommandGroupPlacement.pasteboard) {}
			CommandGroup(replacing: CommandGroupPlacement.windowList) {}
			CommandGroup(replacing: CommandGroupPlacement.windowSize) {}
			CommandGroup(replacing: CommandGroupPlacement.toolbar) {}
			CommandGroup(replacing: CommandGroupPlacement.sidebar) {}
		}
	}
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
	@Published var isFocused = true

	func applicationDidBecomeActive(_ notification: Notification) {
		isFocused = true
	}

	func applicationWillResignActive(_ notification: Notification) {
		isFocused = false
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		true
	}
}
