//
//  ViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit

class ViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    let loginTF: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Имя"
        tf.clearButtonMode = .always
        tf.backgroundColor = .systemGray5
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordTF: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .always
        tf.backgroundColor = .systemGray5
        tf.borderStyle = .roundedRect
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
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь не найден"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        button.layer.cornerRadius = 7
        button.tintColor = .black
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isHidden = true
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .systemBlue
        //button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        button.layer.cornerRadius = 7
        button.tintColor = .black
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        atributtedTextName()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.setAnimation(button: self.loginButton, or: self.nameAppLabel, duration: 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.setAnimation(button: self.registerButton, or: nil, duration: 1)
        }
        
        nameAppLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155, y: 150, width: 310, height: 40)
        view.addSubview(nameAppLabel)
        
        loginTF.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                                          y: view.bounds.size.height / 2 - 25,
                                          width: 310,
                                          height: 40)
                loginTF.addTarget(self, action: #selector(showLabel), for: .editingDidEndOnExit)
                view.addSubview(loginTF)

        passwordTF.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                               y: view.bounds.size.height / 2 + 25,
                               width: 310,
                               height: 40)
        
        passwordTF.addTarget(self, action: #selector(showLabel), for: .editingDidEndOnExit)
        view.addSubview(passwordTF)
        
        textLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155, y: passwordTF.frame.origin.y + 50, width: 310, height: 30)
        view.addSubview(textLabel)
        
        loginButton.frame = CGRect(x: view.bounds.size.width / 2  - 75, y: passwordTF.frame.origin.y + 100 , width: 150, height: 40)
        loginButton.addTarget(self, action: #selector(saveConfig), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2  - 75, y: passwordTF.frame.origin.y + 150 , width: 150, height: 40)
        registerButton.addTarget(self, action: #selector(saveConfig), for: .touchUpInside)
        view.addSubview(registerButton)
        
    }
    
    @objc func showLabel() {
        
        
    }
    
    @objc func saveConfig() {
        
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 58.0/255.0, alpha: 0.5).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
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
    
    func setAnimation(button: UIButton?, or label: UILabel?, duration: CFTimeInterval) {
        let animationLayer = CABasicAnimation(keyPath: "opacity")
        animationLayer.fromValue = 0
        animationLayer.toValue = 1
        animationLayer.duration = duration
        animationLayer.isRemovedOnCompletion = false
        animationLayer.fillMode = .backwards
        
        button?.layer.add(animationLayer, forKey: nil)
        button?.isHidden = false
        
        label?.layer.add(animationLayer, forKey: nil)
        nameAppLabel.isHidden = false
    }
}
