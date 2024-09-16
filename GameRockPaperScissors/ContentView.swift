//
//  ContentView.swift
//  GameRockPaperScissors
//
//  Created by Serge Eliseev on 31.05.2024.
//

import SwiftUI

struct ContentView: View {
    // Переменные состояния для отслеживания состояния игры и ввода пользователя
    @State private var gestures = ["Rock", "Paper", "Scissors"] // Варианты жестов для игры
    @State private var correctAnswer = Int.random(in: 0...2) // Случайный выбор жеста компьютера
    @State private var userGestures = "" // Выбор жеста пользователем
    @State private var buttonGestures = "" // Жест, выбранный кнопкой
    @State private var showingInfo = false // Показывать ли информационный алерт
    @State private var correctGameResult = false
    @State private var gameStatusFigure = "" // Результат игры ("Вы выиграли!" или "Вы проиграли!")
    @State private var userName = "" // Имя пользователя
    
    // Переменные состояния для отображения уведомлений и отслеживания состояния выигрыша/проигрыша
    @State private var showAlertWin = false // Показывать ли алерт при выборе выигрыша
    @State private var showAlertLose = false // Показывать ли алерт при выборе проигрыша
    @State private var winOrLose = false // Состояние: выиграть (true) или проиграть (false)
    @State private var finalStatus = false
    
    // Переменные состояния для отслеживания результата игры
    @State private var userCorrect = 0 // Количество правильных попыток пользователя
    @State private var userWrong = 0 // Количество неправильных попыток пользователя
    @State private var userAttempt = 0 // Общее количество попыток пользователя
    
    var body: some View {
          ZStack {
              // Градиентный фон
              LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.yellow, Color.orange, Color.mint]), startPoint: .topLeading, endPoint: .bottomTrailing)
                  .edgesIgnoringSafeArea(.all) // Градиент будет растянут на весь экран
              
              VStack {
                  ZStack {
                      NavigationView {
                          // Форма для ввода имени игрока
                          Form {
                              Section {
                                  Text("Здравствуйте, введите ваше имя:")
                                  TextField("Your name", text: $userName) // Поле для ввода имени пользователя
                                      .padding(10) // Добавляем отступы внутри текстового поля
                                      .background(Color.white.opacity(0.3)) // Устанавливаем полупрозрачный фон
                                      .cornerRadius(10) // Закругляем углы
                              }
                              .listRowBackground(Color.clear) // Убирает фон секции
                          }
                          .background(Color.clear) // Прозрачность фона формы
                          .scrollContentBackground(.hidden) // Убирает фон списка в iOS 16+
                      }
                      .frame(width: 350, height: 140) // Устанавливает размер формы
                      .cornerRadius(5)
                      .padding(30)
                  }


                  // Текст для выбора выигрыша или проигрыша
                  TextStyle(text: "Вы хотите выиграть или проиграть игру?")
                      .font(.title3)
                      .foregroundColor(.black)
                  
                  // Отображение выбора пользователя
                  Text("\(winOrLose ? "Вы выбрали выиграть!" : "Вы выбрали проиграть!")")
                      .background(Color.yellow.opacity(0.5))
                      .padding(1)
                  
                  HStack {
                      // Кнопки для выбора выигрыша или проигрыша с уведомлением
                      Spacer()
                      Button(action: {
                          winOrLose = true
                          showAlertWin = true // Показываем уведомление о выборе выигрыша
                      }) {
                          ImageTextStyle(text: "\u{1F3C6}") // Иконка трофея
                      }
                      .alert(isPresented: $showAlertWin) {
                          Alert(
                              title: Text("Вы выбрали выиграть!"),
                              dismissButton: .default(Text("OK")) {
                                  showAlertWin = false // Скрываем алерт после нажатия "OK"
                              }
                          )
                      }
                      
                      Spacer()
                      Button(action: {
                          winOrLose = false
                          showAlertLose = true // Показываем уведомление о выборе проигрыша
                      }) {
                          ImageTextStyle(text: "\u{1F926}") // Иконка facepalm
                      }
                      .alert(isPresented: $showAlertLose) {
                          Alert(
                              title: Text("Вы выбрали проиграть!"),
                              dismissButton: .default(Text("OK")) {
                                  showAlertLose = false // Скрываем алерт после нажатия "OK"
                              }
                          )
                      }
                      Spacer()
                  }
                  .padding(30)

                  // Текст для выбора жеста
                  TextStyle(text: "Выбери одну из фигур:")
                      .font(.title3)
                      .foregroundColor(.black)
                  
                  HStack {
                      Spacer()
                      
                      // Кнопка для выбора жеста "Rock"
                      Button(action: {
                          buttonGestures = gestures[0] // Выбор "Rock"
                          showingInfo = true // Показать результат игры
                          gameStatusFigure = gameStatus(figureUser: buttonGestures, figureComputer: gestures[correctAnswer]) // Определение результата игры
                          userResault(winLose: winOrLose, gameStatus: gameStatusFigure) // Обновление результатов игры
                      }) {
                          ImageTextStyle(text: "\u{1FAA8}") // Иконка камня
                      }
                      .alert(isPresented: $showingInfo) {
                          Alert(
                              title: Text("Вы выбрали: \(buttonGestures). Компьютер выбрал: \(gestures[correctAnswer])"),
                              dismissButton: .default(Text("\(gameStatusFigure)")) // Отображение результата игры
                          )
                      }
                      Spacer()
                      
                      // Кнопка для выбора жеста "Paper"
                      Button(action: {
                          buttonGestures = gestures[1] // Выбор "Paper"
                          showingInfo = true
                          gameStatusFigure = gameStatus(figureUser: buttonGestures, figureComputer: gestures[correctAnswer])
                          userResault(winLose: winOrLose, gameStatus: gameStatusFigure)
                      }) {
                          ImageTextStyle(text: "\u{1F4DC}") // Иконка бумаги
                      }
                      .alert(isPresented: $showingInfo) {
                          Alert(
                              title: Text("Вы выбрали: \(buttonGestures). Компьютер выбрал: \(gestures[correctAnswer])"),
                              dismissButton: .default(Text("\(gameStatusFigure)"))
                          )
                      }
                      Spacer()
                      
                      // Кнопка для выбора жеста "Scissors"
                      Button(action: {
                          buttonGestures = gestures[2] // Выбор "Scissors"
                          showingInfo = true
                          gameStatusFigure = gameStatus(figureUser: buttonGestures, figureComputer: gestures[correctAnswer])
                          userResault(winLose: winOrLose, gameStatus: gameStatusFigure)
                      }) {
                          ImageTextStyle(text: "\u{2702}") // Иконка ножниц
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
                  
                  VStack {
                      // Отображение информации о текущем состоянии игры
                      Text("Привет \(userName)!")
                          .font(.title2)
                          .background(Color.blue.opacity(0.1))
                      Text("У вас есть 10 попыток. \(userAttempt) из 10.") // Количество попыток
                      Text("Правильно: \(userCorrect).")
                          .foregroundColor(.green) // Количество правильных ответов
                      Text("Неверно: \(userWrong).")
                          .foregroundColor(.red) // Количество неправильных ответов
                  }
                  .background(Color.white.opacity(0.3))
                  .cornerRadius(11) // Закругленные края
              }
          }
      }

    // Функция для определения результата игры на основе выбранных жестов
     func gameStatus(figureUser: String, figureComputer: String) -> String {
         switch (figureUser, figureComputer) {
         case let(user, computer) where user == computer:
             return "Ничья, повторите попытку!"
         case ("Rock", "Scissors"), ("Scissors", "Paper"), ("Paper", "Rock"):
             return "Вы выиграли!"
         case ("Scissors", "Rock"), ("Paper", "Scissors"), ("Rock", "Paper"):
             return "Вы проиграли!"
         default:
             return "Unexpected case."
         }
     }

    // Функция для обновления результатов игры на основе текущего состояния
      func userResault(winLose: Bool, gameStatus: String) {
          switch (winLose, gameStatus) {
          case (true, "Вы выиграли!"), (false, "Вы проиграли!"):
              userCorrect += 1 // Увеличиваем счетчик правильных ответов
          case (true, "Вы проиграли!"), (false, "Вы выиграли!"):
              userWrong += 1 // Увеличиваем счетчик неправильных ответов
          case (true, "Ничья, повторите попытку!"), (false, "Ничья, повторите попытку!"):
              userWrong += 0 // Ничья, счетчик не меняется
          default:
              print("Error")
          }
          userAttempt += 1 // Увеличиваем количество попыток
          
          // Сброс игры после 10 попыток
          if userAttempt == 11 {
            resetGame()
        }
    }
    
    // Функция для сброса состояния игры
    func resetGame() {
        userCorrect = 0
        userWrong = 0
        userAttempt = 0
        correctAnswer = Int.random(in: 0...2) // Сгенерировать новый случайный жест для компьютера
    }

    // Пользовательский вид для отображения текста в графическом стиле
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

    // Пользовательский вид для отображения стилизованного текста
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
