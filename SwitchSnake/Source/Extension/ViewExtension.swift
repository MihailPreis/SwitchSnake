//
//  ViewExtension.swift
//  SwitchSnake
//
//  Created by Mike Price on 14.05.2021.
//

import SwiftUI

extension View {
	@ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
		if shouldHide { hidden() }
		else { self }
	}
}
