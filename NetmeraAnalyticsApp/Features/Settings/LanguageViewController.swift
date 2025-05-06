import UIKit

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let languages = [
        (code: "tr", display: NSLocalizedString("language_turkish", comment: "")),
        (code: "en", display: NSLocalizedString("language_english", comment: "")),
        (code: "ar", display: NSLocalizedString("language_arabic", comment: ""))
    ]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("language_title", comment: "")
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language.display
        if language.code == LanguageManager.shared.currentLanguage {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = languages[indexPath.row].code
        LanguageManager.shared.currentLanguage = selectedLanguage
        tableView.reloadData()
        // Uygulamanın ana ekranını yeniden başlatmak için aşağıdaki kodu kullanabilirsiniz
        let alert = UIAlertController(title: nil, message: NSLocalizedString("language_restart_message", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
                delegate.reloadRootViewControllerForLanguageChange()
            }
        })
        present(alert, animated: true)
    }
}

