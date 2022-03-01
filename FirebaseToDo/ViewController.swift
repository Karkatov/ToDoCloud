//
//  ViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя"
        tf.clearButtonMode = .always
        tf.backgroundColor = .systemGray5
        tf.borderStyle = .roundedRect
        tf.isHidden = true
        tf.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .always
        tf.backgroundColor = .systemGray5
        tf.borderStyle = .roundedRect
        tf.isHidden = true
        tf.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
        return tf
    }()
    
    let nameAppLabel: UILabel = {
        let label = UILabel()
        label.text = "FirebaseToDo"
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let warningTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь не найден"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
        button.layer.cornerRadius = 7
        button.tintColor = .systemBlue
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isHidden = true
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7
        button.tintColor = .systemBlue
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isHidden = true
        return button
    }()
    var gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        
        atributtedTextName()
        showStartAnimation()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
}

extension ViewController {
    
    func setLayout() {
        
        nameAppLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155, y: 150, width: 310, height: 40)
        view.addSubview(nameAppLabel)
        
        emailTF.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                               y: view.bounds.size.height / 2 - 25,
                               width: 310,
                               height: 40)
        view.addSubview(emailTF)
        
        passwordTF.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                                  y: view.bounds.size.height / 2 + 25,
                                  width: 310,
                                  height: 40)
        view.addSubview(passwordTF)
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155, y: passwordTF.frame.origin.y + 50, width: 310, height: 30)
        view.addSubview(warningTextLabel)
        
        loginButton.frame = CGRect(x: view.bounds.size.width / 2  - 75, y: passwordTF.frame.origin.y + 100 , width: 150, height: 40)
        loginButton.addTarget(self, action: #selector(loginPapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2  - 75, y: passwordTF.frame.origin.y + 150 , width: 150, height: 40)
        registerButton.addTarget(self, action: #selector(registration), for: .touchUpInside)
        view.addSubview(registerButton)
    }
    
    func setGradientBackground() -> CAGradientLayer {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 58.0/255.0, alpha: 0.5).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        
       return gradientLayer
    }
    
    func atributtedTextName() {
        
        let text: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 45)
        ]
        let text2: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 45),
            .foregroundColor : UIColor.red
        ]
        
        let atributedString = NSMutableAttributedString(string: "Firebase", attributes: text)
        atributedString.append(NSAttributedString(string: "ToDo", attributes: text2))
        nameAppLabel.attributedText = atributedString
    }
    
    func setAnimation(button: UIButton?, label: UILabel?, textField: UITextField?, duration: CFTimeInterval) {
        let animationLayer = CABasicAnimation(keyPath: "opacity")
        animationLayer.fromValue = 0
        animationLayer.toValue = 1
        animationLayer.duration = duration
        animationLayer.isRemovedOnCompletion = false
        animationLayer.fillMode = .backwards
        
        button?.layer.add(animationLayer, forKey: nil)
        button?.isHidden = false
        
        textField?.layer.add(animationLayer, forKey: nil)
        textField?.isHidden = false
        
        label?.layer.add(animationLayer, forKey: nil)
        nameAppLabel.isHidden = false
    }
    
    func showStartAnimation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.setAnimation(button: nil, label: self.nameAppLabel, textField: nil, duration: 0.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.setAnimation(button: nil, label: nil, textField: self.emailTF, duration: 0.5)
            self.setAnimation(button: nil, label: nil, textField: self.passwordTF, duration: 0.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.setAnimation(button: self.loginButton, label: nil, textField: nil, duration: 0.5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.setAnimation(button: self.registerButton, label: nil, textField: nil, duration: 0.5)
        }
    }
    
    @objc func loginPapped() {
        
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning(withText: warningTextLabel.text!)
            print("2")
            return }
        
        let firebase = Firebase.Auth.auth().signIn(withEmail: <#T##String#>, password: <#T##String#>)
        
    }
    
    @objc func registration() {
        
    }
    
    @objc func nextWindow() {
        
        let secondVC = SecondViewController()
        navigationController?.pushViewController(secondVC, animated: true)
        print("DONE")
    }
    
    func displayWarning(withText text: String) {
        warningTextLabel.text = text
        
        UIView.animate(withDuration: 7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warningTextLabel.alpha = 1
            print(1)
        } completion: { [weak self] complite in
            self?.warningTextLabel.alpha = 0
            print(3)
        }
    }
}
