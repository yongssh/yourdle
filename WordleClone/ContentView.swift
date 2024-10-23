//
//  ContentView.swift
//  WordleClone
//
//  Created by Yong-Yu Huang on 23/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = WordleGame()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Yourdle")
                .font(.system(size: 36, weight: .bold, design: .serif))
                .padding()

            // Display guesses
            ForEach(0..<6, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { col in
                        Text(game.guesses[row].count > col ?
                             String(game.guesses[row][game.guesses[row].index(game.guesses[row].startIndex, offsetBy: col)]) : "")
                            .frame(width: 50, height: 50)
                            .background(game.colors[row][col])
                            .cornerRadius(8)
                            .font(.custom("EBGaramond-VariableFont_wght", size: 24))                     }
                }
            }

            // input field for guesses
            TextField("Enter your guess", text: $game.currentGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    game.submitGuess()
                }
                .disabled(game.gameOver)

           
            Button("Submit") {
                game.submitGuess()
            }
            .font(.custom("EBGaramond-VariableFont_wght", size: 20))
            .padding()
            .disabled(game.currentGuess.count != 5 || game.gameOver)

            // show messages
            if let message = game.message {
                Text(message)
                    .foregroundColor(.red)
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .padding()
            }

            // reset game
            Button("Reset Game") {
                game.resetGame()
            }
            .font(.system(size: 36, weight: .bold, design: .serif))
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
