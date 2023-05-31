//
//  ContentView.swift
//  ConstantsFolderApp
//
//  Created by Кирилл Прокофьев on 26.05.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                Text(Constants.title)
                    .font(.largeTitle)
                    .padding(.top, Constants.spacing)

                Text(Constants.step1)
                    .font(.headline)

                Text(Constants.step2)
                    .font(.headline)
            }

            Spacer()

            Button(action: {
                openURL(URL(string: Constants.githubLink)!)
            }) {
                Text(Constants.credits)
                    .foregroundColor(.white)
            }
            .font(.footnote)
        }
        .frame(
            minWidth: Constants.minWidth,
            maxWidth: .infinity,
            minHeight: Constants.minHeight,
            maxHeight: .infinity
        )
        .padding(Constants.spacing)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Constants

private extension ContentView {
    enum Constants {
        static let title: String = "Инструкция по установке и запуску Xcode Extension \"ConstantsFolder\""
        static let step1: String = "Шаг 1: Перейдите в System Preferences -> Extensions -> Xcode Source Editor и включите расширение."
        static let step2: String = "Шаг 2: Откройте Xcode, расширение будет доступно во кладке Editor."
        static let credits: String = "Credits: Created by Kirill Prokofyev"
        static let githubLink: String = "https://github.com/prokyhouse"
        static let spacing: CGFloat = 20.0
        static let minHeight: CGFloat = 300
        static let minWidth: CGFloat = minHeight * 2
    }
}
