//
//  ViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let tasksVC = MainTasksViewController()
    var check = false
    let ud = UserDefaults.standard
    let spiner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView()
        spin.color = .white
        spin.style = .large
        spin.hidesWhenStopped = true
        return spin
    }()
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
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "blur")
        imageView.image = image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        check = ud.object(forKey: "check") as? Bool ?? false
        checkUser()
        navigationItem.hidesBackButton = true
        
        atributtedTextName()
        showStartAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
        tabBarController?.setMyTabBar(tabBarController: tabBarController!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        passwordTF.text = "Sktrue53"
        emailTF.text = "Duxxless53@ya.ru"
    }
}

extension LoginViewController {
    
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
    
    @objc func loginTapped() {
        
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning(withText: "Ошибка")
            spiner.stopAnimating()
            return }
        
        spiner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                
                self?.displayWarning(withText: "Ошибка")
                self?.spiner.stopAnimating()
                return
            }
            
            if user != nil {
                
                self!.check = true
                self!.ud.set(self!.check, forKey: "check")
                self!.ud.set(email, forKey: "email")
                self!.ud.set(password, forKey: "password")
                
                self?.navigationController?.pushViewController(self!.tasksVC, animated: true)
                
                self?.spiner.stopAnimating()
                self?.dismiss(animated: true)
                return
            }
            self?.spiner.stopAnimating()
            self?.tabBarController?.tabBar.layer.cornerRadius = 30
            self?.displayWarning(withText: "Пользователь не найден")
        }
    }
    
    @objc func registerTapped() {
        
        let signUpview = RegisterViewController()
        signUpview.emailTF.text = self.emailTF.text
        present(signUpview, animated: true)
    }
    
    func displayWarning(withText text: String) {
        
        warningTextLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warningTextLabel.alpha = 1
            
        } completion: { [weak self] _ in
            self?.warningTextLabel.alpha = 0
        }
    }
    
    func checkUser() {
        if check == true {
            spiner.startAnimating()
            let saveEmail = (ud.object(forKey: "email") as? String)!
            let savePassword = (ud.object(forKey: "password") as? String)!
            Auth.auth().signIn(withEmail: saveEmail, password: savePassword) { [weak self] (user, error) in
                guard error == nil else {
                    self?.spiner.stopAnimating()
                    return }
                self?.spiner.stopAnimating()
                self?.navigationController?.pushViewController(self!.tasksVC, animated: true)
                self?.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension LoginViewController {
    func setLayout() {
    
        backgroundImageView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height)
        view.addSubview(backgroundImageView)
        
        nameAppLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                                    y: 150,
                                    width: 310,
                                    height: 40)
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
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                        y: passwordTF.frame.origin.y + 50,
                                        width: 300,
                                        height: 30)
        view.addSubview(warningTextLabel)
        
        loginButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                   y: passwordTF.frame.origin.y + 100 ,
                                   width: 300,
                                   height: 40)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                      y: passwordTF.frame.origin.y + 150,
                                      width: 300,
                                      height: 40)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        spiner.frame = CGRect(x: view.bounds.size.width / 2 - 25 , y: nameAppLabel.frame.origin.y + 100, width: 50, height: 50)
        view.addSubview(spiner)
    }
}
