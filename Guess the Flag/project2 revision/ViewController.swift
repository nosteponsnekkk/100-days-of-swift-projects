import UIKit

extension String { // extension для заглавной буквы
    func uppercasedFirstSymbol() -> String {
        return String (prefix(1).uppercased() + self.dropFirst())
    }
}

var flags = [String]() // массив для флагов
var correctAnswer = 0 // номер правильного ответа
var score = 0 // очки игрока

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton! // подключаем все три кнопки
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    func askQuestion(action: UIAlertAction!) { // метод для начала игры
              correctAnswer = Int.random(in: 0...2) // берем за правильный ответ случайную цифру от 0 до 2
              flags.shuffle() // перемешиваем массив флагов
              button1.setImage(UIImage(named: flags[0]), for: .normal) // загружаем картинки в кнопки
              button2.setImage(UIImage(named: flags[1]), for: .normal)
              button3.setImage(UIImage(named: flags[2]), for: .normal)
    if flags[correctAnswer].count == 9 { // для UK и US
    title = flags[correctAnswer].replacingOccurrences(of: "@3x.png", with: "").uppercased() // задаем название заглавными буквами и удаляем лишний суффикс
    } else {
    title = flags[correctAnswer].replacingOccurrences(of: "@3x.png", with: "").uppercasedFirstSymbol()} // для остальных стран делаем только первую букву заглавной
    }
             
    override func viewDidLoad() {
        super.viewDidLoad()

        let buttons = [button1, button2, button3]
      
        let fm = FileManager.default // создаем константу для работы с fileManager
        let path = Bundle.main.resourcePath! // создаем константу для работы с путем к нашим файлам
        let items = try! fm.contentsOfDirectory(atPath: path) // загоняем в константу файлы с нашего bundle

        for item in items{ // ищем файлы с суффиксом @3x.png
            if item.hasSuffix("@3x.png") {
                flags.append(item) // вставляем в массив
            }
        }

        for button in buttons { // настраиваем вид кнопок
            button?.layer.borderColor = UIColor.black.cgColor // делаем рамку черной
            button?.layer.borderWidth = 2 // делаем рамку размером в 2 points
            button?.layer.shadowColor = UIColor.black.cgColor // делаем тень черного цвета
            button?.layer.shadowRadius = 2 // радиус тени 2 points
            button?.layer.shadowOpacity = 0.3 // прозрачность тени
        }
       askQuestion(action: nil) // запускаем игру
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) { // подключаем action outlet для работы с нажатием на кнопку
        var title: String // переменная для сообщения
        if sender.tag == correctAnswer { // по тегу кнопки определяем сообщение
        title = "Correct" // если тег = правильный ответ, то выдаем сообщение о правильном выборе
        score += 1 // добавляем очко
        } else { // в противном случае
            title = "Wrong" // выдаем сообщение о неправильном выборе
            score -= 1 // и выитает очко
        }
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert) // создаем alertController
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion)) // добавляем кнопку продолжения игры
        present(ac, animated: true) // показываем alertController
    }
}

