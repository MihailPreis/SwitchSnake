//
//  MainView.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import SwiftUI

struct MainView: View {
	@Binding var isShowGame: Bool

	var body: some View {
		VStack{
			Button("NEXT") {
				withAnimation {
					isShowGame = true
				}
			}
			Text("This is the first view")
		}
	}
}
