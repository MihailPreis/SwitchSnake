//
//  GameView.swift
//  SwitchSnake
//
//  Created by Mike Price on 07.04.2021.
//

import SwiftUI
import Combine

struct GameView: View {
	private var gameLoop = Timer.publish(every: 1.0 / Constants.FPS, tolerance: 0.1, on: .current, in: .common).autoconnect()
	@EnvironmentObject private var appDelegate: AppDelegate
	@ObservedObject private var gameState = GameState()
	@State private var isAppeared = false

	var body: some View {
		VStack {
			ForEach(gameState.level.indices) { rowIndex in
				HStack {
					ForEach(gameState.level[rowIndex].indices) { itemIndex in
						Toggle("", isOn: $gameState.level[Int(rowIndex)][Int(itemIndex)].isOn.animation())
							.toggleStyle(SwitchToggleStyle(tint: Color.green))
							.onTapGesture {}
					}
				}
			}
		}
		.navigationTitle(gameState.title)
		.padding([.top, .trailing,. bottom], 10)
		.background(gameState.keyEventHandling)
		.onReceive(gameLoop) { _ in
			gameState.tick(isFocused: appDelegate.isFocused && isAppeared)
		}
		.alert(isPresented: $gameState.isShowGameOverAlert) {
			Alert(
				title: Text("👾 GAME OVER 👾"),
				message: Text(gameState.gameOverType.message),
				primaryButton: .default(Text("New game"), action: { self.gameState.reset() }),
				secondaryButton: .destructive(Text("EXIT"), action: { exit(EXIT_SUCCESS) })
			)
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				isAppeared = true
			}
		}
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		GameView()
	}
}
#endif
