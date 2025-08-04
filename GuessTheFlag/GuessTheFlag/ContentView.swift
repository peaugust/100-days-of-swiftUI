//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Pedro Freddi on 22/07/25.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var currentQuestion = 1
    @State private var shouldRestartGame = false
    @State private var tappedAnswer: Int? = nil
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))

                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if let tappedAnswer = tappedAnswer {
                Text("That flag is from \(countries[tappedAnswer]).")
            } else {
                Text("Right choice")
            }
        }
        .alert("Endgame", isPresented: $shouldRestartGame) {
            Button("Reset", action: resetGame)
        } message: {
            Text("Your final score is: \(userScore)")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            tappedAnswer = nil
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            tappedAnswer = number
            scoreTitle = "Wrong!"
        }
        showingScore = true
    }

    func askQuestion() {
        currentQuestion += 1
        if(currentQuestion == 9) {
            shouldRestartGame = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }

    func resetGame() {
        userScore = 0
        currentQuestion = 1
        askQuestion()
    }
}

#Preview {
    ContentView()
}
