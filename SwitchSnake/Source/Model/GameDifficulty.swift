//
//  GameDifficulty.swift
//  SwitchSnake
//
//  Created by Mike Price on 14.05.2021.
//

import Foundation

enum GameDifficulty: String, CaseIterable {
	case easy = "Easy"
	case normal = "Normal"
	case hard = "HARD"

	var interval: TimeInterval {
		let coefficient: Double
		switch self {
		case .easy: coefficient = 1.2
		case .normal: coefficient = 1.0
		case .hard: coefficient = 0.8
		}
		return 1.0 / Constants.FPS * coefficient
	}

	var icon: String {
		switch self {
		case .easy: return "🐔"
		case .normal: return "🥲"
		case .hard: return "🔥"
		}
	}
}
