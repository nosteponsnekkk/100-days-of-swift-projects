//
//  ViewController.swift
//  Challenge 1 revision
//
//  Created by Олег Наливайко on 4/18/23.
//  Copyright © 2023 Олег Наливайко. All rights reserved.
//

import UIKit

extension String { // extension для заглавной буквы
    func uppercasedFirstSymbol() -> String {
        return String (prefix(1).uppercased() + self.dropFirst())
    }
}

class ViewController: UITableViewController { // подкулючаем TableView

    var flags = [String]() // массив для флагов
    var names = [String]() // массив для названий стран
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Flags" // название приложения
        navigationController?.navigationBar.prefersLargeTitles = true // делаем название большими буквами
        
        let fm = FileManager.default // создаем константу для связи с FileManager
        let path = Bundle.main.resourcePath! // создаем путь к файлам в нашем Bundle
        let items = try! fm.contentsOfDirectory(atPath: path) // задаем путь через константы выше для того чтобы загрузить их в отдельную константу

        for item in items { // каждую вещь проверяем
            if item.hasSuffix("@3x.png"){ // на наличие суффикса пнг
            flags.append(item) // вставляем в массив с флагами
            if item.count == 9 { // если название 9 букв (т.е. US@3x.png UK@3x.png)
            names.append(item.replacingOccurrences(of: "@3x.png", with: "").uppercased()) // вставляем названия, удаляем суффикс, делаем обе буквы заглавной
            } else {
            names.append(item.replacingOccurrences(of: "@3x.png", with: "").uppercasedFirstSymbol()) // вставляем названия, убираем суффикс и делаем первую букву заглавной
            }
        }
    }

        
flags.sort() // сортируем
names.sort() // сортируем
print(flags) // выводим для проверки
print(names) // выводим для проверки

}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // методв для задания количества строк
        return names.count // количество строк = количество названий стран
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // метод для создания ячеек
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // создаем утилизируемую ячейку
        cell.textLabel?.text = names[indexPath.row] // название ячейки
        cell.imageView?.image = UIImage(named: flags[indexPath.row]) // картинка для ячейки
        return cell // возвращаем ячейку
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // метод для работы после нажатия на ячейку
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController { // работаем с DetailViewController
            vc.selectedImage = flags[indexPath.row] //отправляем картинку
            vc.selectedName = names[indexPath.row] // отправляем имя
            navigationController?.pushViewController(vc, animated: true) // показываем DetailViewController
        }
        
    }
    
}

