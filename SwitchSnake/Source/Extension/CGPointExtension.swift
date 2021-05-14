//
//  CGPointExtension.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import Foundation

extension CGPoint {
	var yInt: Int { Int(y) }
	var xInt: Int { Int(x) }

	static var rand: CGPoint {
		CGPoint(x: Int.random(in: 0..<Constants.TILE_WIDTH), y: Int.random(in: 0..<Constants.TILE_HEIGHT))
	}
}
