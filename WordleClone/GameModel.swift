import Foundation
import SwiftUI
import Combine

class ColorManager: ObservableObject {
    @Published var steelGray = Color(white: 0.4745)
}

class WordleGame: ObservableObject {
    private let words = WordList
    
    // instance of ColorManager.
    private var colorManager = ColorManager()
    
    @Published var correctWord: String
    @Published var currentGuess: String = ""
    @Published var guesses: [String] = Array(repeating: "", count: 6)
    
    // just use steelgray color directly bc of access issues?? understand more about this
    @Published var colors: [[Color]] = Array(repeating: Array(repeating: Color(white: 0.4745), count: 5), count: 6)
    @Published var attempts = 0
    @Published var gameOver = false
    @Published var message: String?

    init() {
        // picks a random word and converts it to all caps.
        self.correctWord = words.randomElement()!.uppercased()
    }

    // to submit guess
    func submitGuess() {
        // checks if it's 5 letters.
        guard currentGuess.count == 5 else {
            message = "Guess must be 5 letters!"
            return
        }

        // if it's the correct word, print message, set gameOver to true.
        if currentGuess.uppercased() == correctWord {
            message = "Congratulations! You guessed it!"
            gameOver = true
            
            // else, increment attempts, call checkGuess.
        } else if attempts < 5 {
            checkGuess()
            attempts += 1
            currentGuess = ""
        } else { // 5 tries
            message = "Game over! The word was \(correctWord)."
            gameOver = true
        }
    }

    private func checkGuess() {
        let uppercasedGuess = currentGuess.uppercased()
        for (idx, letter) in uppercasedGuess.enumerated() {
            let correctLetterIndex = correctWord.index(correctWord.startIndex, offsetBy: idx)
            
            if letter == correctWord[correctLetterIndex] {
                colors[attempts][idx] = .green
            } else if correctWord.contains(letter) {
                colors[attempts][idx] = .yellow
            } else {
                // here i can use colorManager to access steelGray.
                colors[attempts][idx] = colorManager.steelGray
            }
        }
        guesses[attempts] = uppercasedGuess
    }

    func resetGame() {
        currentGuess = ""
        guesses = Array(repeating: "", count: 6)
        // here i can use colorManager to access steelGray.
        colors = Array(repeating: Array(repeating: colorManager.steelGray, count: 5), count: 6)
        gameOver = false
        message = nil
        // Re-pick a new correct word
        self.correctWord = words.randomElement()!.uppercased()
    }
}
