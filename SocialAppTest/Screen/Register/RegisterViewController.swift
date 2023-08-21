//
//  LoginViewController.swift
//  SocialAppTest
//
//  Created by AsherFelix on 17/08/2023.
//

import UIKit
import Alamofire
import SwiftHEXColors
import MBProgressHUD
class RegisterViewController: UIViewController {
    var passwordShow = false
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameErro: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErro: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var passwordErro: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmail()
        setupUsername()
        setupPassword()
    }
    private func setupUsername() {
        usernameErro.isHidden = true
        usernameTF.placeholder = "Input Username"
        usernameTF.layer.borderColor = UIColor.black.cgColor
        usernameTF.layer.cornerRadius = 5
        usernameTF.layer.borderWidth = 1
        usernameTF.backgroundColor = .white
    }
    private func setupUsernameErro() {
        usernameErro.isHidden = false
        usernameTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        usernameTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        usernameTF.layer.cornerRadius = 5
        usernameTF.layer.borderWidth = 1
    }
    private func setupEmail() {
        emailErro.isHidden = true
        emailTF.placeholder = "Input Email"
        emailTF.layer.borderColor = UIColor.black.cgColor
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderWidth = 1
        emailTF.backgroundColor = .white
    }
    private func setupEmailErro() {
        emailErro.isHidden = false
        emailTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        emailTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderWidth = 1
    }
    private func setupPassword() {
        passwordErro.isHidden = true
        passwordTF.isSecureTextEntry = true
        passwordTF.placeholder = "Input Password"
        passwordTF.layer.borderColor = UIColor.black.cgColor
        passwordTF.layer.cornerRadius = 5
        passwordTF.layer.borderWidth = 1
        passwordTF.backgroundColor = .white
    }
    private func setupPasswordErro() {
        passwordErro.isHidden = false
        passwordTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        passwordTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        passwordTF.layer.cornerRadius = 5
        passwordTF.layer.borderWidth = 1
    }
    
    @IBAction func showPasswordBtn(_ sender: Any) {
        passwordShow.toggle()
        if passwordShow == true {
            passwordTF.isSecureTextEntry = false
            passwordImage.image = UIImage(named: "hiddenpassword")
        } else {
            passwordTF.isSecureTextEntry = true
            passwordImage.image = UIImage(named: "showpassword")
        }
    }
    func isValidRegister(_ email: String) -> Bool {
        let registerRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let registerTest = NSPredicate(format: "SELF MATCHES %@", registerRegex)
        return registerTest.evaluate(with: email)
    }
    @IBAction func registerBtn(_ sender: Any) {
        let usernameCheck = usernameTF.text ?? ""
        var usernamePass = false
        if usernameCheck.isEmpty {
            usernameLabel.text = "Username can't Empty"
            setupUsernameErro()
        } else if usernameCheck.count < 6 || usernameCheck.count > 40 {
            usernameLabel.text = "Username must been 6 and 40 character"
            setupUsernameErro()
        }else if !usernameCheck.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            usernameLabel.text = "Username must not have spaces"
            setupEmailErro()
        }else {
            setupUsername()
            usernamePass = true
        }
        let emailCheck = emailTF.text ?? ""
        var emailPass =  false
        if emailCheck.isEmpty {
            emailLabel.text = "Email can't Empty"
            setupEmailErro()
        } else if emailCheck.count < 6 || emailCheck.count > 40 {
            emailLabel.text = "Email must been 6 and 40 character"
            setupEmailErro()
        }else if !isValidRegister(emailCheck) {
            emailLabel.text = "Invalid Email"
            setupEmailErro()
        }else {
            setupEmail()
            emailPass = true
        }
        let passwordCheck: String = passwordTF.text ?? ""
        var passwordPass = false
        if passwordCheck.isEmpty {
            passwordLabel.text = "Password can't Empty"
            setupPasswordErro()
        }else if passwordCheck.count < 6 || passwordCheck.count > 40 {
            passwordLabel.text = "Password must been 6 and 40 character"
            setupPasswordErro()
        }else if !passwordCheck.contains(where: {$0.isUppercase}){
            passwordLabel.text = "Password need one Uppercase"
            setupPasswordErro()

        }
        else if !passwordCheck.contains(where: {!$0.isLetter && !$0.isNumber}) {
            passwordLabel.text = "Incorrect password format"
            setupPasswordErro()
        } else {
            setupPassword()
            passwordPass = true
        }
        let isValid = usernamePass && emailPass && passwordPass
        if isValid == true {
            callApiRegister()
        }
    }
    private func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func callApiRegister() {
        self.showLoading(isShow: true)
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/register"
        AF.request(domain,
                   method: .post,
                   parameters: [
                    "username": usernameTF.text ?? "",
                    "name": emailTF.text ?? "",
                    "password": passwordTF.text ?? ""
                   ],
                    encoder: JSONParameterEncoder.default
        )
        .validate(statusCode: 200..<299)
        .responseData { afDataResponse in
            self.showLoading(isShow: false)
            switch afDataResponse.result {
            case .success(let data):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        return
                    }
                    print(json)
                    let accessToken = json["access_token"] as? String
                    let refreshToken = json["refresh_token"] as? String
                    let userId = json["user_id"] as? String
                    let loginReponse = LoginResponseByManual(userId: userId,
                                                             accessToken: accessToken, refreshToken: refreshToken)
                    let isLoggedIn = loginReponse.accessToken != nil
                    if isLoggedIn {
                        self.alertRegisterSuccess()
                    } else {
                        self.alertRegisterFail(message: "Login Failure")
                    }
                } catch {
                    print("erroMsg")
                }
            case.failure(let erro):
                print(erro.errorDescription ?? "")
                do {
                    guard let data = afDataResponse.data else {
                        self.alertRegisterFail(message: erro.errorDescription ?? "Something went wrong")
                        return
                    }
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        self.alertRegisterFail(message: erro.errorDescription ?? "Something went wrong")
                        return
                    }
                    let type = json["type"] as? String
                    let message =  json["message"] as? String
                    self .alertRegisterFail(titel: type, message: message ?? "Something went wrong")
                    print(json)
                }catch {
                    print("erroMsg")
                    self.alertRegisterFail(message: erro.errorDescription ?? "Something went wrong")
                }
            }
        }
    }
    private func alertRegisterSuccess() {
        let alertVc = UIAlertController(title: "Note", message: "RegisterSuccess", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel)
        alertVc.addAction(doneAction)
        present(alertVc, animated: true)
    }
    private func alertRegisterFail(titel: String? =  "Note", message: String) {
        let alertFail = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        let failAction = UIAlertAction(title: "Try Again", style: .cancel)
        alertFail.addAction(failAction)
        present(alertFail, animated: true)
    }
    @IBAction func loginBtn(_ sender: Any) {
        dismiss(animated: true)
    }
}
    
