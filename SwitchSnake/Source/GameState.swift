//
//  GameState.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import SwiftUI

class GameState: ObservableObject {
	@Published var level: [[LevelTileType]] = emptyLevel
	@Published var title = makeTitle(score: 0)
	@Published var hasApple = false
	@Published var snakeLen = Constants.START_SNAKE_LENGTH {
		didSet { title = GameState.makeTitle(score: snakeLen - Constants.START_SNAKE_LENGTH) }
	}
	@Published var snakePath: [CGPoint] = []
	@Published var moveDirection: MoveDirection = .right
	@Published var moveDirectionBuffer: MoveDirection?
	@Published var isPause = false
	@Published var wallMode = true
	@Published var isShowGameOverAlert = false
	@Published var gameOverType: GameOverType = .none {
		didSet { isShowGameOverAlert = gameOverType != .none }
	}

	var keyEventHandling: KeyEventHandling {
		KeyEventHandling(handler: self.keyHandler(_:))
	}

	func tick(isFocused: Bool) {
		if (snakePath.isEmpty && snakeLen > 0) {
			snakePath = genSnakePath()
		}

		makeAppleIfNeeded()

		guard isFocused else { return }

		move()
	}

	func reset() {
		level = Array(repeating: Array(repeating: .empty, count: Constants.TILE_WIDTH), count: Constants.TILE_HEIGHT)
		title = GameState.makeTitle(score: 0)
		hasApple = false
		snakeLen = Constants.START_SNAKE_LENGTH
		snakePath = []
		moveDirection = .right
		moveDirectionBuffer = nil
		isPause = false
		gameOverType = .none
	}

	private func move() {
		guard !isPause && !isShowGameOverAlert else { return }

		moveDirectionBuffer.flatMap {
			switch $0 {
			case .down where moveDirection != .up:
				self.moveDirection = .down
			case .up where moveDirection != .down:
				self.moveDirection = .up
			case .left where moveDirection != .right:
				self.moveDirection = .left
			case .right where moveDirection != .left:
				self.moveDirection = .right
			default:
				break
			}
		}
		moveDirectionBuffer = nil

		guard var point = self.snakePath.last else { return }

		switch moveDirection {
		case .up: point.y -= 1
		case .right: point.x += 1
		case .left: point.x -= 1
		case .down: point.y += 1
		}

		if (!(0..<Constants.TILE_HEIGHT).contains(point.yInt) || !(0..<Constants.TILE_WIDTH).contains(point.xInt)) && !wallMode {
			gameOverType = .outOfPlace
		} else {
			let oldPoint = snakePath.remove(at: 0)
			guard oldPoint != point else {
				gameOverType = .selfToggle
				return
			}
			level[oldPoint.yInt][oldPoint.xInt] = .empty

			if wallMode {
				if !(0..<Constants.TILE_HEIGHT).contains(point.yInt) {
					point.y = CGFloat(point.yInt >= Constants.TILE_HEIGHT ? 0 : Constants.TILE_HEIGHT - 1)
				} else if !(0..<Constants.TILE_WIDTH).contains(point.xInt) {
					point.x = CGFloat(point.xInt >= Constants.TILE_WIDTH ? 0 : Constants.TILE_WIDTH - 1)
				}
			}

			switch level[point.yInt][point.xInt] {
			case .apple:
				snakeLen += 1
				snakePath.insert(oldPoint, at: 0)
				level[oldPoint.yInt][oldPoint.xInt] = .snake
				hasApple = false

			case .snake:
				gameOverType = .selfToggle
				return

			case .empty:
				level[oldPoint.yInt][oldPoint.xInt] = .empty
			}

			level[point.yInt][point.xInt] = .snake
			snakePath.append(point)
		}
	}

	private func keyHandler(_ keyType: KeyType) {
		switch keyType {
		case .arrowDown:
			moveDirectionBuffer = .down
		case .arrowUp:
			moveDirectionBuffer = .up
		case .arrowLeft:
			moveDirectionBuffer = .left
		case .arrowRight:
			moveDirectionBuffer = .right
		case .pause:
			isPause.toggle()
		case .restart:
			reset()
		}
	}

	private func makeAppleIfNeeded() {
		guard !hasApple else { return }
		var point = CGPoint.rand
		while (level[point.yInt][point.xInt] == .snake) {
			point = CGPoint.rand
		}
		level[point.yInt][point.xInt] = .apple
		hasApple = true
	}

	private func genSnakePath() -> [CGPoint] {
		(0..<Constants.START_SNAKE_LENGTH).reduce([]) { (acc, ind) -> [CGPoint] in
			let y: Int = Constants.TILE_HEIGHT / 2
			level[y][ind] = .snake
			return acc + [CGPoint(x: ind, y: y)]
		}
	}

	private static var emptyLevel: [[LevelTileType]] {
		Array(repeating: Array(repeating: .empty, count: Constants.TILE_WIDTH), count: Constants.TILE_HEIGHT)
	}

	private static func makeTitle(score: Int, isFirst: Bool = false) -> String {
		"🐍 - Score: \(score)"
	}
}
