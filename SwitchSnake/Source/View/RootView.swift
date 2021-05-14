//
//  RootView.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import SwiftUI

struct RootView: View {
	@ObservedObject private var settings = GameSettings()

	var body: some View {
		ZStack {
			MainView(settings: settings)
				.hidden(settings.isShowGame)
			GameView()
				.environmentObject(settings)
				.hidden(!settings.isShowGame)
		}
		.navigationTitle(settings.title)
	}
}
