//
//  GameView.swift
//  SwitchSnake
//
//  Created by Mike Price on 07.04.2021.
//

import SwiftUI

let TILE_HEIGHT = 20
let TILE_WIDTH = 15
let START_SNAKE_LENGTH = 10
let FPS = 60.0

enum ObjectType: String {
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

enum MoveDirection {
	case right
	case left
	case up
	case down
}

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

struct GameView: View {
	private let gameLoop = Timer.publish(every: 1.0 / FPS, on: .main, in: .common).autoconnect()

	@State private var level: [[ObjectType]] = Array(repeating: Array(repeating: .empty, count: TILE_WIDTH), count: TILE_HEIGHT)
	@State private var title = makeTitle(score: 0)
	@State private var hasApple = false
	@State private var snakeLen = START_SNAKE_LENGTH
	@State private var snakePath: [CGPoint] = []
	@State private var moveDirection: MoveDirection = .right
	@State private var moveDirectionBuffer: MoveDirection?
	@State private var isPause = false
	@State private var wallMode = false
	@State private var isShowGameOverAlert = false
	@State private var gameOverType: GameOverType = .none {
		didSet { isShowGameOverAlert = gameOverType != .none }
	}

	var body: some View {
		VStack {
			ForEach(level.indices) { rowIndex in
				HStack {
					ForEach(level[rowIndex].indices) { itemIndex in
						Toggle("", isOn: $level[Int(rowIndex)][Int(itemIndex)].isOn.animation())
							.toggleStyle(SwitchToggleStyle(tint: Color.green))
							.onTapGesture {}
					}
				}
			}
		}
		.navigationTitle(title)
		.padding([.top, .trailing,. bottom], 10)
		.alert(isPresented: $isShowGameOverAlert) {
			Alert(
				title: Text("👾 GAME OVER 👾"),
				message: Text(gameOverType.message),
				primaryButton: .default(Text("New game"), action: { self.resetGame() }),
				secondaryButton: .destructive(Text("EXIT"), action: { exit(EXIT_SUCCESS) })
			)
		}
		.background(KeyEventHandling { keyType in
			switch keyType {
			case .arrowDown:
				self.moveDirectionBuffer = .down
			case .arrowUp:
				self.moveDirectionBuffer = .up
			case .arrowLeft:
				self.moveDirectionBuffer = .left
			case .arrowRight:
				self.moveDirectionBuffer = .right
			case .pause:
				self.isPause.toggle()
			case .restart:
				resetGame()
			}
		})
		.onReceive(gameLoop) { (input) in
			if (snakePath.isEmpty && snakeLen > 0) {
				snakePath = genSnakePath()
			}

			makeAppleIfNeeded()

			if !isPause && !isShowGameOverAlert {
				move()
			}

			title = makeTitle(score: snakeLen - START_SNAKE_LENGTH)
		}
	}

	private func resetGame() {
		level = Array(repeating: Array(repeating: .empty, count: TILE_WIDTH), count: TILE_HEIGHT)
		title = makeTitle(score: 0)
		hasApple = false
		snakeLen = START_SNAKE_LENGTH
		snakePath = []
		moveDirection = .right
		moveDirectionBuffer = nil
		isPause = false
		gameOverType = .none
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

	private func move() {
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

		if (!(0..<TILE_HEIGHT).contains(point.yInt) || !(0..<TILE_WIDTH).contains(point.xInt)) && !wallMode {
			gameOverType = .outOfPlace
		} else {
			let oldPoint = snakePath.remove(at: 0)
			guard oldPoint != point else {
				gameOverType = .selfToggle
				return
			}
			level[oldPoint.yInt][oldPoint.xInt] = .empty

			if wallMode {
				if !(0..<TILE_HEIGHT).contains(point.yInt) {
					point.y = CGFloat(point.yInt >= TILE_HEIGHT ? 0 : TILE_HEIGHT - 1)
				} else if !(0..<TILE_WIDTH).contains(point.xInt) {
					point.x = CGFloat(point.xInt >= TILE_WIDTH ? 0 : TILE_WIDTH - 1)
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

	private func genSnakePath() -> [CGPoint] {
		(0..<START_SNAKE_LENGTH).reduce([]) { (acc, ind) -> [CGPoint] in
			let y: Int = TILE_HEIGHT / 2
			level[y][ind] = .snake
			return acc + [CGPoint(x: ind, y: y)]
		}
	}
}

func makeTitle(score: Int, isFirst: Bool = false) -> String {
	"🐍 - Score: \(score)"
}

extension CGPoint {
	var yInt: Int { Int(y) }
	var xInt: Int { Int(x) }

	static var rand: CGPoint {
		CGPoint(x: Int.random(in: 0..<TILE_WIDTH), y: Int.random(in: 0..<TILE_HEIGHT))
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		GameView()
	}
}
#endif
