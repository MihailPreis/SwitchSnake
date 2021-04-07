//
//  KeyEventHandler.swift
//  SwitchSnake
//
//  Created by Mike Price on 07.04.2021.
//

import Foundation
import SwiftUI

enum KeyType: Int {
	case pause = 35
	case restart = 36
	case arrowLeft = 123
	case arrowRight = 124
	case arrowDown = 125
	case arrowUp = 126
}

struct KeyEventHandling: NSViewRepresentable {
	private let handler: (KeyType) -> Void

	init(handler: @escaping (KeyType) -> Void) {
		self.handler = handler
	}

	func makeNSView(context: Context) -> NSView {
		KeyView(handler: handler).withMakeFirstResponder()
	}

	func updateNSView(_ nsView: NSView, context: Context) {}
}

private class KeyView: NSView {
	private let handler: (KeyType) -> Void

	override var acceptsFirstResponder: Bool { true }

	init(handler: @escaping (KeyType) -> Void) {
		self.handler = handler
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func keyUp(with event: NSEvent) {
		super.keyUp(with: event)
		guard let keyType = KeyType(rawValue: Int(event.keyCode)) else {
			return
		}
		handler(keyType)
	}

	func withMakeFirstResponder() -> Self {
		DispatchQueue.main.async {
			self.window?.makeFirstResponder(self)
		}
		return self
	}
}
