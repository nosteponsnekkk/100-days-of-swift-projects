import UIKit

extension String { // extension для заглавной буквы
    func uppercasedFirstSymbol() -> String{
        return String (prefix(1).uppercased() + self.dropFirst())
    }
}

class ViewController: UITableViewController { // подключаем TableView
    var allWords = [String]() // массив для подгурзки слов из файла
    var usedWords = [String]() // массив для создания слов

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer)) // создаем кнопку для добавления слова
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame)) // создаем кнопку для обновления слова
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") { // находим файл со словами
            if let startWords = try? String(contentsOf: startWordsURL) { // находим слова в файле
                allWords = startWords.components(separatedBy: "\n") // вытягиваем слова из файла и добавляем в массив
            }
        }
            if allWords.isEmpty { // если массив оказался пустым, то добавляем одно запасное слово
            allWords = ["Silkworm"]
        }
        
        startGame() // запускаем игру
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // указываем количество строк
        return usedWords.count // количество строк = массив использованых слов
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // функция для создания ячеек
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath) // создаем утилизируемую ячейку
        cell.textLabel?.text = usedWords[indexPath.row] // лейбл ячейки = usedWords[номер строки, на которой находится ячейка]
        return cell // возвращаем ячейку
    }
    
    @objc func startGame() { // метод для обновления TableView и начала игры
        title = allWords.randomElement()?.uppercasedFirstSymbol() // задаём слово в название
        usedWords.removeAll(keepingCapacity: true) // очищаем массив использованых слов
        tableView.reloadData() // обновляем TableView
    }
    
    @objc func promptForAnswer() { // функция для ввода слова
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField() // добавляем поле для ввода текста
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { // создаем кнопку для добавления слова
            [weak self, weak ac] _ in // указываем тип захвата. Ставим слабый захват для того что бы избежать retain cycle
            guard let answer = ac?.textFields?[0].text else {return} // вытягиваем текст из текстового поля
            self?.submit(answer) // переводим вытянутый ответ в другой метод submit
    }
        
        ac.addAction(submitAction) // добавляем кнопку для добавления слова
        present(ac, animated: true) // показываем оповещение
    }
    
    
    func submit(_ answer: String) { // метод для добавления слова в массив использованых слов
        
        let errorTitle: String
        let errorMessage: String
        
        let lowerAnswer = answer.lowercased() // убираем заглавные буквы с введенного слова
        guard let originalWord = title?.lowercased() else {return} // вытягиваем оригинальное слова
        
        if isPossible(word: lowerAnswer) { // проверка 1
            if isOriginal(word: lowerAnswer) { // проверка 2
                if isReal(word: lowerAnswer) { // проверка 3
                    if isTheSameWord(word: lowerAnswer){ // проверка 4
                        if !lowerAnswer.isEmpty { // проверка 5. Не является ли ответ пустым
                            
                        usedWords.insert(answer.lowercased().uppercasedFirstSymbol(), at: 0) // вставляем слово в массив
                        let indexPath = IndexPath(row: 0, section: 0) // задаем IndexPath
                        tableView.insertRows(at: [indexPath], with: .automatic) // вставляем слово в TableView по заданому IndexPath и выбираем анимацию
                        return // выходим из нашего метода
                            
                        } else { // сообщение для ошибки проверки 1
                             errorTitle = "The Answer is empty"
                             errorMessage = "Please enter the answer"
                        }
                    } else { // сообщение для ошибки проверки 2
                            errorTitle = "The answer can't be the original word!"
                            errorMessage = "You can't use \(originalWord)"
                    }
                } else { // сообщение для ошибки проверки 3
                            errorTitle = "The answer is invalid"
                            errorMessage = "The typed word does not exist!"
                }
            } else { // сообщение для ошибки проверки 4
                            errorTitle = "The answer has already been used"
                            errorMessage = "Be more creative!"
            }
        } else { // сообщение для ошибки проверки 5
                            errorTitle = "You can't just make them up"
                            errorMessage = "You can't make it from \(originalWord)"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert) // создаем оповещение об ошибке
        ac.addAction(UIAlertAction(title: "Continue", style: .default)) // кнопка для продолжения игры
        present(ac, animated: true) // показываем кнопку
    }
    
    
    func isPossible(word: String) -> Bool { // проверка возможно ли составить слово из оригинального слова
        guard var tempWord = title?.lowercased() else { return false } // вытягиваем из названия оригинальное слово
        for letter in word { // проверяем каждую букву в слове
            if let position = tempWord.firstIndex(of: letter) { // проверяем существует ли буква из word в tempWord
                tempWord.remove(at: position ) // если буква найдена, то удаляем ее из tempWord. Таким образом предотвращаем использование отсутствующих букв и повторение одной буквы неограниченое количество раз
                    } else { return false } // если проверка букв провалена, то возвращаем false
    }
    return true // если проверка удалась то возвращаем true
    }
    
    func isOriginal(word: String) -> Bool { // проверка не повторялось ли слово
        return !usedWords.contains(word.lowercased().uppercasedFirstSymbol()) // проверяем есть ли слово в массиве использованых слов
    }
    
    func isReal(word: String) -> Bool { // проверка существует ли слово
        let checker = UITextChecker() // создаем константу для взаемодействия с UITextChecker
        let range = NSRange (location: 0, length: word.utf16.count) // задаем диапазон  NSRange
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en") // задаем наше слово, диапазон проверки слова, начало проверки слова, выключаем проверку слова до указаного старта проверки (так как мы проверяем все слово), задаем язык
        return misspelledRange.location == NSNotFound // если не было найдено ни одной ошибки (то есть слово существует), возвращаем true
    }
    
    func isTheSameWord(word: String) -> Bool { // проверка не оригинальное ли это слово
        guard let tempWord = title?.lowercased() else {return false} // вытягиваем из названия оригинальное слово
        return word.lowercased() != tempWord // если слово является заданным словом, возвращаем false
    }
    
}

