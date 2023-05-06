import UIKit
import WebKit // Добавляем WebKit

class ViewController: UIViewController, WKNavigationDelegate { // подвязываемся к протоколу WKNavigationDelegate для использования методов протоколоа (en - conforming to a protocol)

    var webView: WKWebView! // создаем переменную-референс к WKWebView, чтобы взаемодействовать с WKWebView через неё
    var progressView: UIProgressView! // создаем переменную-референс к UIProgressView
    var websites = ["www.apple.com", "youtube.com"] // создаем список веб-сайтов
    
    override func loadView() { // вместо пустого экрана в Storyboard подгружаем наш код
        webView = WKWebView() // создаем новый экземпляр компонента WKWebView и привязываем его к webView
        webView.navigationDelegate = self // привязываем navigationDelegate к ViewController. Это позволяет нашему ViewController получать информацию о том что происходит на экране WebView
        view = webView // делаем WebView видом для нашего ViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openTapped)) // создаем кнопку с сохраненными сайтами
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)) // создаем кнопку обновления страницы
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // создаем гибкое пустое пространство
        
        progressView = UIProgressView(progressViewStyle: .default) // переменная ссылается на UIProgressView. Выбираем стандартный стиль
        progressView.sizeToFit() // оптимизация размера
        let progressButton = UIBarButtonItem(customView: progressView) // создание кастомной кнопки, изображающей прогресс
        
        toolbarItems = [progressButton, spacer, refresh] // добавляем элементы в toolbar
        navigationController?.isToolbarHidden = false // показываем toolbar
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) // добавляем наблюдатель, позволяющий мониторить прогресс загрузки страницы (WKWebView.estimatedProgress)
        
        let url = URL(string: "https://" + websites[0])! // создаем ссылку
        webView.load(URLRequest(url: url)) // подгружаем ссылку в webView
        webView.allowsBackForwardNavigationGestures = true // разрешаем использование жестов
    }

    @objc func openTapped() { // Создаем функцию, показывающую список сайтов
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet) // основа списка
        for website in websites{
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage)) // добавляем сайты
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel)) // кнопка отмены
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // чтобы не вылетало на iPad
        present(ac, animated: true) // показываем список
    }
    
    func openPage(action: UIAlertAction) { // функция для открытия сайта со списка. Функция принимает параметры с функции openTapped
        guard let actionTitle = action.title else {return} // распаковываем значение с action.title
        guard let url = URL(string: "https://" + actionTitle) else {return} // создаем URL
        webView.load(URLRequest(url: url)) // подгружаем URL
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // функция ответственна за работу с сайтом по окончанию его загрузки
        title = webView.title // ставим название сайта в navigation bar
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) { // обязательный метод для наблюдателя
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress) // обновляем значение progressView до значения webView.estimatedProgress
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) { // метод, проверяющий ссылку. Позволяет не открывать определенные ссылки
        let url = navigationAction.request.url // константа относящаяся к ссылке
        if let host = url?.host { // достаем хост с ссылки
            for website in websites { // проверяем хост каждого сайта
                if host.contains(website) { // если хост найден, то
                    decisionHandler(.allow) // разрешаем открытие ссылки
                    return // выходим из метода
                }
            }
        }
        decisionHandler(.cancel) // запрещаем открытие ссылки
    }
}

