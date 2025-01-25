//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Francisco Manuel Gallegos Luque on 19/01/2025.
//



//struct ContentView: View {
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//                Color.red
//                Color.blue
//            }
//            
//            Text("Your content")
//                .foregroundStyle(.secondary)
//                .padding(50)
//                .background(.ultraThinMaterial)
//        }
//        
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        //        LinearGradient(stops: [
//        //            Gradient.Stop(color: .white, location: 0.45),
//        //            Gradient.Stop(color: .black, location: 0.55),
//        //        ], startPoint: .top, endPoint: .bottom)
//        
//        //        RadialGradient(colors: [.blue,.black], center: .center, startRadius: 20, endRadius: 200)
//        
//        //        AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center)
//        
//        //        Text("Your content")
//        //            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        //            .foregroundStyle(.white)
//        //            .background(.indigo.gradient)
//        
//        //        Button("Delete selection", role: .destructive, action: executeDelete)
//        Image(systemName: "pencil.circle")
//            .foregroundStyle(.red)
//            .font(.largeTitle)
////        VStack {
////            Button("Button 1") { }
////                .buttonStyle(.bordered)
////            
////            Button("Buttton 2", role: .destructive) { }
////                .buttonStyle(.bordered)
////            Button("Button 3") { }
////                .buttonStyle(.borderedProminent)
////            Button("Button 4", role: .destructive) { }
////                .buttonStyle(.borderedProminent)
//            Button {
//                print("Button was tapped")
//            } label: {
//                Label("Edit", systemImage: "pencil")
//                    .padding()
//                    .foregroundStyle(.white)
//                    .background(.red)
//            }
////        }
//        
//    }
//    func executeDelete(){
//        print("Now deleting...")
//    }
//}

//struct ContentView: View {
//    @State private var showingAlert = false
//
//    var body: some View {
//        Button("Show Alert") {
//            showingAlert = true
//        }
//        .alert("Important message", isPresented: $showingAlert) {
//            Button("Delete", role: .destructive) { }
//            Button("Cancel", role: .cancel) { }
//        } message: {
//            Text("Pleas read this.")
//        }
//    }
//}

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 6)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.semibold))
            .foregroundStyle(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View{
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""

    @State private var userScore = 0
    @State private var questionsAsked = 0
    
    @State private var gameEnded: Bool = false
    
    @State private var animationAmount = 0.0
    @State private var fadingAmount = 1.0
    @State private var flagSelected: Int = 0
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: .red, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation {
                                animationAmount += 360
                                fadingAmount = 0.25
                            }
                        
                        } label: {
                            FlagImage(country: countries[number])
                                .rotation3DEffect(.degrees(flagSelected == number ? animationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                                
                        }
                        .opacity(flagSelected == number ? 1.0 : fadingAmount)
                        .scaledToFit()
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        }
        .alert("Game ended. You scored \(userScore) points", isPresented: $gameEnded) {
            Button("New Game", action: reset)
        }
//        } message: {
//            Text("Your score is: \(userScore)")
//        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        flagSelected = number
        showingScore = true
        
    }
    
    func askQuestion() {
        fadingAmount = 1.0
        questionsAsked += 1
        if questionsAsked > 7 { gameEnded.toggle() }
        else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked = 0
        userScore = 0
        gameEnded.toggle()
        
    }
}

#Preview {
    ContentView()
}

//Classes vs structs

//Classes don’t come with a memberwise initializer; structs get these by default.

//Classes can use inheritance to build up functionality; structs cannot.

//If you copy a class, both copies point to the same data; copies of structs are always unique.

//Classes can have deinitializers; structs cannot.

//You can change variable properties inside constant classes; properties inside constant structs are fixed regardless of whether the properties are constants or variables.
