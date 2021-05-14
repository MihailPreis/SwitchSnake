//
//  GameSettings.swift
//  SwitchSnake
//
//  Created by Mike Price on 14.05.2021.
//

import Combine

class GameSettings: ObservableObject {
	@Published var difficulty: GameDifficulty = .easy
	@Published var isWallMode: Bool = true
	@Published var title: String = "🐍 SwitchSnake 🐍"
	@Published var isShowGame: Bool = false {
		didSet {
			if !isShowGame {
				title = "🐍 SwitchSnake 🐍"
			}
		}
	}
}
