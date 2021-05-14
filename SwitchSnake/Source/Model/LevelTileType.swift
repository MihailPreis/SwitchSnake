//
//  LevelTileType.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import Foundation

enum LevelTileType: String {
	case empty
	case snake
	case apple

	var isOn: Bool {
		get {
			switch self {
			case .snake, .apple: return true
			default: return false
			}
		}
		set {}
	}
}
