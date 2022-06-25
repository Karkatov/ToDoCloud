

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    let tableVC = TasksTableViewController()
    var loginViewController: LoginViewController!
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
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
        tf.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let text: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5),
            .font : UIFont.systemFont(ofSize: 20)
        ]
        
        var placehold = NSMutableAttributedString(string: "Пароль", attributes: text)
        tf.attributedPlaceholder = placehold
        return tf
    }()
    
    let passwordTwoTF: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let text: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5),
            .font : UIFont.systemFont(ofSize: 20)
        ]
        
        var placehold = NSMutableAttributedString(string: "Повторите пароль", attributes: text)
        tf.attributedPlaceholder = placehold
        return tf
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
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 0.6).cgColor
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    var gradient = CAGradientLayer()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "blur")
        imageView.image = image
        return imageView
    }()
    
    
    let vc = LoginViewController()
    var ref = DatabaseReference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("users")
        navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
}

extension RegisterViewController {
    
    func setLayout() {
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        view.addSubview(backgroundImageView)
        
        emailTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                               y: view.bounds.size.height / 2 - 50,
                               width: 300,
                               height: 40)
        view.addSubview(emailTF)
        
        passwordTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                  y: view.bounds.size.height / 2,
                                  width: 300,
                                  height: 40)
        view.addSubview(passwordTF)
        
        passwordTwoTF.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                     y: view.bounds.size.height / 2 + 50,
                                     width: 300,
                                     height: 40)
        view.addSubview(passwordTwoTF)
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                        y: passwordTF.frame.origin.y + 50,
                                        width: 300,
                                        height: 30)
        view.addSubview(warningTextLabel)
        
        registerButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                      y: passwordTwoTF.frame.origin.y + 100 ,
                                      width: 300,
                                      height: 40)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        cancelButton.frame = CGRect(x: view.bounds.size.width / 2 - 150,
                                    y: passwordTwoTF.frame.origin.y + 150,
                                    width: 300,
                                    height: 40)
        cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        view.addSubview(cancelButton)
        view.addSubview(passwordTwoTF)
        
        warningTextLabel.frame = CGRect(x: view.bounds.size.width / 2 - 155,
                                        y: passwordTwoTF.frame.origin.y + 50,
                                        width: 310,
                                        height: 30)
        
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
    }
    
    @objc func registerTapped() {
        registerButton.isEnabled = false
        guard passwordTF.text == passwordTwoTF.text else {
            self.displayWarning("Пароль не подтвержден", speed: 3)
            registerButton.isEnabled = true
            return }
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning("Заполните поля", speed: 3)
            registerButton.isEnabled = true
            return
        }
        var count = 0
        for _ in passwordTF.text! {
            count += 1 }
        if count < 6 {
            displayWarning("Пароль слишком короткий", speed: 3)
            registerButton.isEnabled = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (user, error) in
            
            guard error == nil else {
                displayWarning("Oшибка сети", speed: 3)
                print(error!.localizedDescription)
                registerButton.isEnabled = true
                return
            }
            guard user != nil else { return }
            
            let userRef = ref.child((user?.user.uid)!)
            
            userRef.setValue(["email" : user?.user.email,
                              "password" : passwordTF.text!])
            setUserDefaults()
            displayWarning("Регистрация пройдена!", speed: 1)
            loginViewController.emailTF.text = emailTF.text
            loginViewController.passwordTF.text = passwordTF.text
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func displayWarning(_ text: String, speed: Double) {
        warningTextLabel.text = text
        UIView.animate(withDuration: speed, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [unowned self] in
            warningTextLabel.alpha = 1
            
        } completion: { [weak self] complite in
            self?.warningTextLabel.alpha = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    private func setUserDefaults() {
        vc.check = true
        vc.ud.set(vc.check, forKey: "check")
        vc.ud.set(emailTF.text!, forKey: "email")
        vc.ud.set(passwordTF.text!, forKey: "password")
    }
}
