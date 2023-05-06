//
//  DetailViewController.swift
//  Challenge 1 revision
//
//  Created by Олег Наливайко on 4/18/23.
//  Copyright © 2023 Олег Наливайко. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView! // прикрепляем imageView
    var selectedImage: String? // переменная для распаковки картинки
    var selectedName: String? // переменная для получения названия
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = selectedImage { // распаковываем картинку
            imageView.image = UIImage(named: imageToLoad) // загоняем ее в imageView
        }
        
        title = selectedName //задаем название для вкладки
        navigationItem.largeTitleDisplayMode = .never // выключаем большие буквы для названия
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,  target: self, action: #selector(shareTapped)) // создаем кнопку для того чтобы делиться картинкой
        
         }
    
    
    override func viewWillDisappear(_ animated: Bool) { // метод для того чтобы рамки оставались
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    override func viewWillAppear(_ animated: Bool) { // метод для того чтобы рамки прятались при нажатии
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    
    @objc func shareTapped() { // ф-ция для того чтобы делиться картинкой
        guard let image = imageView.image?.pngData() else { // вытягиваем картинку из imageView
            print("no image found") //если картинка отсутствует то выдаем ошибку
            return // выход из метода
        }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: []) // создаем список действий для нашей кнопки
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // показываем кнопку на iPad
        present(ac, animated: true) // показываем нашу кнопку
    }
    
        }
        
        
     
    

  


