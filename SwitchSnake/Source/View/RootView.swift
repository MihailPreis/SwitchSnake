//
//  RootView.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import SwiftUI

struct RootView: View {
	@State private var isShowGame = false

	var body: some View {
		if !isShowGame {
			MainView(isShowGame: $isShowGame)
				.navigationTitle("🐍 SwitchSnake 🐍")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.blue)
		}
		if isShowGame {
			GameView()
		}
	}
}
