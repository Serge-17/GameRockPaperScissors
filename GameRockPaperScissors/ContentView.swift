//
//  ContentView.swift
//  GameRockPaperScissors
//
//  Created by Serge Eliseev on 31.05.2024.
//
import SwiftUI

struct ContentView: View {
    @State private var gestures = ["Rock", "Paper", "Scissors"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userGestures = ""
    @State private var buttonGestures = ""
    @State private var showingInfo = false
    @State private var correctGameResult = false
    @State private var gameStatusFigure = ""
    @State private var userName = ""
    
    
    @State private var showAlertWin = false
    @State private var showAlertLose = false
    @State private var winOrLose = false
    @State private var finalStatus = false
    
    @State private var userCorrect = 0
    @State private var userWrong = 0
    @State private var userAttempt = 0
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.yellow, Color.orange, Color.mint]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    NavigationView {
                        // Форма ввода имени игрока
                        Form {
                            Section {
                                Text ("Здраствуйте, введите ваше имя:")
                                TextField ("Your name", text: $userName)
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .frame(width: 350, height:140)
                    .cornerRadius(5)
                    .padding(30)
                }


                //Выбор из вариата проиграть или вытиграть игру
                TextStyle(text: "Вы хотите выиграть или проиграть игру?")
                    .font(.title3)
                    .foregroundColor(.black)
                // Отображение выбронного вариата игрока
                Text("\(winOrLose ? "Вы выбрали выиграть!" : "Вы выбрали проиграть!")")
                    .background(Color.yellow.opacity(0.5))
                    .padding(1)
                
                
                HStack{
                    // Реализуем кнопки выбора проигрыша или выигриша через иконку
                    //Дополнительно уведомляем через пуш еведомление о выборе
                    Spacer()
                    Button(action: {
                        winOrLose = true
                        showAlertWin = true
                    }) {
                        ImageTextStyle(text: "\u{1F3C6}")
                    }
                    .alert(isPresented: $showAlertWin) {
                        Alert(
                            title: Text("Вы выбрали выиграть!"),
                            dismissButton: .default(Text("OK")) {
                                showAlertWin = false
                            }
                        )
                    }
                    
                    
                    Spacer()
                    Button(action: {
                        winOrLose = false
                        showAlertLose = true
                    }) {
                        ImageTextStyle(text: "\u{1F926}")
                    }
                    .alert(isPresented: $showAlertLose) {
                        Alert(
                            title: Text("Вы выбрали проиграть!"),
                            dismissButton: .default(Text("OK")) {
                                showAlertLose = false
                            }
                        )
                    }
                    Spacer()
                }
                .padding(30)

                
                TextStyle(text: "Выбери одну из фигур:")
                    .font (.title3)
                    .foregroundColor(.black)

                
                HStack{
                    Spacer()
                    
                    
                    Button(action: {
                        buttonGestures = gestures[0]
                        showingInfo = true
                        gameStatusFigure =  gameStatus(figureUser: buttonGestures, figureComputer: gestures[correctAnswer])
                        userResault(winLose: winOrLose, gameStatus: gameStatusFigure)
                    }) {
                        ImageTextStyle(text: "\u{1FAA8}")
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(
                            title: Text("Вы выбрали: \(buttonGestures). Компьютер выбрал: \(gestures[correctAnswer])"),
                            dismissButton: .default(Text("\(gameStatusFigure)"))
                        )
                    }
                    Spacer()
                    
                    
                    Button(action: {
                        buttonGestures = gestures[1]
                        showingInfo = true
                        gameStatusFigure =  gameStatus(figureUser: buttonGestures, figureComputer: gestures[correctAnswer])
                        userResault(winLose: winOrLose, gameStatus: gameStatusFigure)
                    }) {
                        ImageTextStyle(text: "\u{1F4DC}")
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(
                            title: Text("Вы выбрали: \(buttonGestures). Компьютер выбрал: \(gestures[correctAnswer])"),
                            dismissButton: .default(Text("\(gameStatusFigure)"))
                        )
                    }
                    Spacer()
                    
                    
                    Button(action: {
                        buttonGestures = gestures[2]
                        showingInfo = true
                        gameStatusFigure =  gameStatus(figureUser: buttonGestures, figureComputer: gestures[correctAnswer])
                        userResault(winLose: winOrLose, gameStatus: gameStatusFigure)
                    }) {
                        ImageTextStyle(text: "\u{2702}")
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(
                            title: Text("Вы выбрали: \(buttonGestures). Компьютер выбрал: \(gestures[correctAnswer])"),
                            dismissButton: .default(Text("\(gameStatusFigure)"))
                        )
                    }
                    Spacer()
                }
                .padding()

                
                VStack{
                    Text("Привет \(userName)!")
                        .font(.title2)
                        .background(Color.blue.opacity(0.1))
                    Text("У вас есть 10 попыток. \(userAttempt) из 10.")
                    Text("Правильно: \(userCorrect).")
                        .foregroundColor(.green)
                    Text("Неверно: \(userWrong).")
                        .foregroundColor(.red)
                }
                .background(Color.white.opacity(0.3))
                .cornerRadius(11)
            }
        }
    }

    
    func gameStatus(figureUser: String, figureComputer: String) -> String {
        switch (figureUser, figureComputer) {
        case let(user, computer) where user == computer:
            return "Ничья,  повторите попытку!"
        case ("Rock", "Scissors"), ("Scissors", "Paper"), ("Paper", "Rock"):
            return "Вы выиграли!"
        case ("Scissors", "Rock"), ("Paper", "Scissors"), ("Rock", "Paper"):
            return "Вы програли!"
        default:
            return "Unexpected case."
        }
    }

    
    func userResault(winLose: Bool,  gameStatus: String) {
        switch (winLose, gameStatus){
        case (true, "Вы выиграли!"), (false, "Вы програли!"):
            userCorrect += 1
        case (true, "Вы програли!"), (false, "Вы выиграли!"):
            userWrong += 1
        case (true, "Ничья,  повторите попытку!"), (false, "Ничья,  повторите попытку!"):
            userWrong += 0
        default:
            print("Eror")
        }
        userAttempt += 1
        
        if userAttempt == 11 {
            resetGame()
        }
    }
    
    
    
    
    func resetGame() {
        userCorrect = 0
        userWrong = 0
        userAttempt = 0
        correctAnswer = Int.random(in: 0...2)
    }

    
    struct ImageTextStyle: View {
        var text: String
        
        var body: some View {
            Text(text)
                .font(.system(size: 90))
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
                .background(Color.white.opacity(0.1))
                .cornerRadius(25)
        }
    }

    
    struct TextStyle: View {
        var text: String
        
        var body: some View {
            Text(text)
                .background(Color.secondary.opacity(0.3))
                .cornerRadius(10)
        }
    }
}

    #Preview {
        ContentView()
    }

