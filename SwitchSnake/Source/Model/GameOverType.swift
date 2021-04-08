//
//  GameOverType.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import Foundation

enum GameOverType {
	case none
	case outOfPlace
	case selfToggle

	var message: String {
		switch self {
		case .outOfPlace: return "You have gone beyond the limits of the playing field."
		case .selfToggle: return "You have touched the tail."
		default: return ""
		}
	}
}
