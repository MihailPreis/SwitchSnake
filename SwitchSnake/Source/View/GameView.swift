//
//  GameView.swift
//  SwitchSnake
//
//  Created by Mike Price on 07.04.2021.
//

import SwiftUI
import Combine

struct GameView: View {
	@EnvironmentObject private var appDelegate: AppDelegate
	@EnvironmentObject private var settings: GameSettings
	@ObservedObject private var gameState = GameState()

	var body: some View {
		VStack {
			ForEach(gameState.level.indices) { rowIndex in
				HStack {
					ForEach(gameState.level[rowIndex].indices) { itemIndex in
						Toggle("", isOn: $gameState.level[Int(rowIndex)][Int(itemIndex)].isOn.animation())
							.toggleStyle(SwitchToggleStyle(tint: Color.green))
							.allowsHitTesting(false)
					}
				}
			}
		}
		.navigationTitle(settings.isShowGame ? gameState.title : settings.title)
		.padding([.top, .trailing,. bottom], 10)
		.background(gameState.keyEventHandling)
		.onReceive(settings.$isShowGame) { isShowGame in
			if !isShowGame {
				gameState.reset()
			} else {
				gameState.difficulty = settings.difficulty
				gameState.wallMode = settings.isWallMode
				gameState.run {
					self.appDelegate.isFocused
				}
			}
		}
		.alert(isPresented: $gameState.isShowGameOverAlert) {
			Alert(
				title: Text("👾 GAME OVER 👾"),
				message: Text(gameState.gameOverType.message),
				primaryButton: .default(Text("New game"), action: { self.settings.isShowGame = false }),
				secondaryButton: .destructive(Text("EXIT"), action: { exit(EXIT_SUCCESS) })
			)
		}
	}
}
