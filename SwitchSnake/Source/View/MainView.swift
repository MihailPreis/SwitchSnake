//
//  MainView.swift
//  SwitchSnake
//
//  Created by Mike Price on 08.04.2021.
//

import SwiftUI

struct MainView: View {
	@ObservedObject var settings: GameSettings

	var body: some View {
		VStack{
			Text("Difficulty")

			Picker(selection: $settings.difficulty, label: EmptyView()) {
				ForEach(GameDifficulty.allCases, id: \.self) { item in
					Text(item.rawValue)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			.scaledToFit()

			Toggle("Wall mode", isOn: $settings.isWallMode)
				.toggleStyle(SwitchToggleStyle(tint: Color.green))
				.padding(.top, 20)

			Button("NEW GAME") {
				settings.isShowGame = true
			}
			.padding(.top, 30)
		}
	}
}
