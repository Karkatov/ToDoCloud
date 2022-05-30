//
//  ViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let tasksVC = TasksListsViewController()
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
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 2
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
        loginButton.isEnabled = true
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        tabBarController?.tabBar.isHidden = true
        passwordTF.text = "qwerty"
        emailTF.text = "Konstantin777@ya.ru"
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
        let text3: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor : UIColor.white
        ]
        
        let atributedString = NSMutableAttributedString(string: "ToDo", attributes: text)
        atributedString.append(NSAttributedString(string: "Cloud        ", attributes: text2))
        atributedString.append(NSAttributedString(string: ""))
        atributedString.append(NSAttributedString(string: "To do list & task", attributes: text3))
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
        loginButton.isEnabled = false
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning(withText: "Ошибка")
            spiner.stopAnimating()
            return }
        
        spiner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (user, error) in
            if error != nil {
                
                self.displayWarning(withText: "Ошибка")
                self.spiner.stopAnimating()
                loginButton.isEnabled = true
                return
            }
            
            if user != nil {
                let currentUser = UserModel(password: password, email: email, check: true)
                
                StorageManager.shared.saveUser(currentUser)

                self.navigationController?.pushViewController(self.tasksVC, animated: true)
                
                self.spiner.stopAnimating()
                return
            }
            self.spiner.stopAnimating()
            self.tabBarController?.tabBar.layer.cornerRadius = 30
            self.displayWarning(withText: "Пользователь не найден")
        }
    }
    
    @objc func registerTapped() {
        
        let signUpview = RegisterViewController()
        signUpview.loginViewController = self
        signUpview.emailTF.text = self.emailTF.text
        present(signUpview, animated: true)
    }
    
    func displayWarning(withText text: String) {
        
        warningTextLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [unowned self] in
            self.warningTextLabel.alpha = 1
            
        } completion: { [unowned self] _ in
            self.warningTextLabel.alpha = 0
        }
    }
    
    func checkUser() {
        let user = StorageManager.shared.getUser()
        if user.check {
            spiner.startAnimating()
            
            Auth.auth().signIn(withEmail: user.email, password: user.password) { [unowned self] (user, error) in
                guard error == nil else {
                    self.spiner.stopAnimating()
                    return }
                self.spiner.stopAnimating()
                self.navigationController?.pushViewController(self.tasksVC, animated: true)
            }
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension LoginViewController {
    func setLayout() {
        
        view.addSubview(backgroundImageView)
        view.addSubview(nameAppLabel)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
        view.addSubview(warningTextLabel)
        view.addSubview(registerButton)
        view.addSubview(spiner)
        
        backgroundImageView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height)
        
        nameAppLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                                    y: view.bounds.size.height / 7,
                                    width: 310,
                                    height: 150)
    
        emailTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                               y: view.bounds.size.height / 2 - 25,
                               width: 300,
                               height: 40)
        
        passwordTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                  y: view.bounds.size.height / 2 + 25,
                                  width: 300,
                                  height: 40)
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                        y: passwordTF.frame.origin.y + 50,
                                        width: 300,
                                        height: 30)
        
        loginButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                   y: passwordTF.frame.origin.y + 100 ,
                                   width: 300,
                                   height: 40)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                      y: passwordTF.frame.origin.y + 150,
                                      width: 300,
                                      height: 40)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        spiner.frame = CGRect(x: view.bounds.size.width / 2 - 25 , y: view.bounds.size.height / 3 + 15, width: 50, height: 50)
        view.addSubview(spiner)
    }
}
