//
//  SwitchSnakeApp.swift
//  SwitchSnake
//
//  Created by Mike Price on 07.04.2021.
//

import SwiftUI

@main
struct SwitchSnakeApp: App {
	var body: some Scene {
		WindowGroup {
			GameView()
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
