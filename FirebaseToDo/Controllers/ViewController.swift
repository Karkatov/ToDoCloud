//
//  ViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let secondVC = TableViewController()
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.isHidden = true
        tf.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let text: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5),
            .font : UIFont.systemFont(ofSize: 20)
        ]
        
        var placehold = NSMutableAttributedString(string: "Имя", attributes: text)
        tf.attributedPlaceholder = placehold
        
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.isHidden = true
        tf.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let text: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5),
            .font : UIFont.systemFont(ofSize: 20)
        ]
        
        var placehold = NSMutableAttributedString(string: "Пароль", attributes: text)
        tf.attributedPlaceholder = placehold
        return tf
    }()
    
    let nameAppLabel: UILabel = {
        let label = UILabel()
        label.text = "FirebaseToDo"
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let warningTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь не найден"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemYellow
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.tintColor = .white
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.isHidden = true
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 0.6).cgColor
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.isHidden = true
        return button
    }()
    var gradient = CAGradientLayer()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "blur")
        imageView.image = image
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        checkUser()
        atributtedTextName()
        showStartAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
        tabBarController?.tabBar.isHidden = true
        tabBarController?.setMyTabBar(tabBarController: tabBarController!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        passwordTF.text = "Sktrue53"
        emailTF.text = "Duxxless53@ya.ru"
    }
}

extension ViewController {
    
    func setLayout() {
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        view.addSubview(backgroundImageView)
        
        
        nameAppLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155, y: 150, width: 310, height: 40)
        view.addSubview(nameAppLabel)
        
        emailTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                               y: view.bounds.size.height / 2 - 25,
                               width: 300,
                               height: 40)
        view.addSubview(emailTF)
        
        passwordTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                  y: view.bounds.size.height / 2 + 25,
                                  width: 300,
                                  height: 40)
        view.addSubview(passwordTF)
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 150, y: passwordTF.frame.origin.y + 50, width: 310, height: 30)
        view.addSubview(warningTextLabel)
        
        loginButton.frame = CGRect(x: view.bounds.size.width / 2 - 150, y: passwordTF.frame.origin.y + 100 , width: 300,
                                   height: 40)
        loginButton.addTarget(self, action: #selector(loginPapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2 - 150, y: passwordTF.frame.origin.y + 150, width: 300,
                                      height: 40)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
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
            displayWarning(withText: "Ошибка")
            return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarning(withText: "Ошибка")
                return
            }
            
            if user != nil {
                
                let tableVC = TableViewController()
                self?.navigationController?.pushViewController(tableVC, animated: true)
                return
            }
            
            self?.tabBarController?.tabBar.layer.cornerRadius = 30
            self?.displayWarning(withText: "Пользователь не найден")
        }
        
    }
    
    @objc func registerTapped() {
    
        let signUpview = SignUpView()
        signUpview.emailTF.text = self.emailTF.text
        present(signUpview, animated: true)
    }
    

    
    func displayWarning(withText text: String) {
        warningTextLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warningTextLabel.alpha = 1
            print(1)
        } completion: { [weak self] complite in
            self?.warningTextLabel.alpha = 0
            print(3)
        }
    }
    
    func checkUser() {
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
