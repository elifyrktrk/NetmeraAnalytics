//
//  LoginViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 13.04.2025.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        // Email ve şifreyi al
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if email.isEmpty || password.isEmpty {
            // Uyarı göster
            showAlert("Lütfen tüm alanları doldurun.")
        } else {
            // Geçici başarı kontrolü
            if email == "test@test.com" && password == "123456" {
                // Başarı → ana ekrana geç
                goToMainScreen()
            } else {
                showAlert("Giriş bilgileri yanlış.")
            }
        }
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func goToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") // Dummy anasayfa
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController {
                registerVC.modalPresentationStyle = .fullScreen
                present(registerVC, animated: true)
            
        }

    }
}

