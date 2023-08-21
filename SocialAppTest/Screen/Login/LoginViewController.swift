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
class LoginViewController: UIViewController {
    var passwordCheck = false
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErro: UIView!
    @IBOutlet weak var emailMessage: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordErro: UIView!
    @IBOutlet weak var passwordShow: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordMessenger: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmail()
        setupPassword()
    
    }
    private func setupEmail() {
        emailErro.isHidden = true
        emailTF.placeholder = "Vui lòng nhập Email của bạn"
        emailTF.font = UIFont.systemFont(ofSize: 14)
        emailTF.keyboardType = .emailAddress
        emailTF.clearButtonMode = .whileEditing
        emailTF.backgroundColor = .white
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderColor = UIColor.black.cgColor
        emailTF.layer.borderWidth = 1
    }
    private func setupEmailErro() {
        emailErro.isHidden = false
        emailTF.layer.borderWidth = 1
        emailTF.layer.cornerRadius = 5
        emailTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
    }
    private func setupPassword() {
        passwordErro.isHidden = true
        passwordTF.font = UIFont.systemFont(ofSize: 14)
        passwordTF.backgroundColor = .white
        passwordTF.layer.cornerRadius = 5
        passwordTF.layer.borderColor = UIColor.black.cgColor
        passwordTF.layer.borderWidth = 1
    }
    private func setupPasswordErro() {
        passwordErro.isHidden = false
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.cornerRadius = 5
        passwordTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        passwordTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    @IBAction func passwordCheckBtn(_ sender: Any) {
        passwordCheck.toggle()
        if passwordCheck == true {
            passwordTF.isSecureTextEntry = false
            passwordImage.image = UIImage(named: "hiddenpassword")
        } else {
            passwordTF.isSecureTextEntry = true
            passwordImage.image = UIImage(named: "showpassword")
        }
    }
    @IBAction func loginBtn(_ sender: Any) {
        var emailPass = false
        let emailCheck: String = emailTF.text ?? ""
        if emailCheck.isEmpty {
            emailMessage.text = "Email can't empty"
            setupEmailErro()
        }else if emailCheck.count < 6 {
            emailMessage.text = "Email must be at least 6 characters long."
            setupEmailErro()
        }else if emailCheck.count > 40 {
            emailMessage.text = "Email is too long"
            setupEmailErro()
        }else if !isValidEmail(emailCheck) {
            emailMessage.text = " Invalid Email"
            setupEmailErro()
        }else {
            setupEmail()
            emailPass = true
        }
        var passwordPass = false
        let passwordCheck:String = passwordTF.text ?? ""
        if passwordCheck.isEmpty {
            passwordMessenger.text = "Password can't empty"
            setupPasswordErro()
        } else if passwordCheck.count < 6 || passwordCheck.count > 40 {
            passwordMessenger.text = "Password must been 6 and 40 character"
            setupPasswordErro()
        }else if !passwordCheck.contains(where: {$0.isUppercase}){
            passwordMessenger.text = "Password need one Uppercase"
            setupPasswordErro()
        }else if !passwordCheck.contains(where: { !$0.isLetter && !$0.isNumber}) {
            passwordMessenger.text = "Incorrect password format"
            setupPasswordErro()
        }else {
            setupPassword()
            passwordPass = true
        }
        let isvalue = emailPass && passwordPass
        if isvalue == true {
            callApiLogin()
        }
    }
    func showLoading(isShow: Bool) {
        
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func callApiLogin() {
        self.showLoading(isShow: true)
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/login"
        AF.request(domain,
                   method: .post,
                   parameters: [
                    "username": emailTF.text ?? "",
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
                    let refressToken = json["refress_token"] as? String
                    let userId = json["user_id"] as? String
                    let isLoggedIn = accessToken != nil
                    if isLoggedIn {
                        self.alertLoginSuccess()
                    } else {
                        self.alertLoginFail(message: "Login Failure")
                    }
                } catch {
                    print("errorMsg")
                }
               
            case .failure(let erro):
                print(erro.errorDescription ?? "")
                do {
                    guard let data = afDataResponse.data else {
                        self.alertLoginFail(message: erro.errorDescription ?? "Something went wrong")
                        return
                    }
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        self.alertLoginFail(message: erro.errorDescription ?? "Something went wrong")
                        return
                    }
                    let type = json["type"] as? String
                    let message =  json["message"] as? String
                    self .alertLoginFail(title: type, message: message ?? "Something went wrong")
                    print(json)
                }catch {
                    print("erroMsg")
                    self.alertLoginFail(message: erro.errorDescription ?? "Something went wrong")
                }
            }
        }
    }
    private func alertLoginSuccess() {
        let alertVc = UIAlertController(title: "Note", message: "Login Success", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel)
        alertVc.addAction(doneAction)
        present(alertVc, animated: true)
    }
    private func alertLoginFail(title: String? = "Note", message: String) {
        let alertVc = UIAlertController(title: "Note", message: message, preferredStyle: .alert)
        let failAction = UIAlertAction(title: "Try Again", style: .cancel)
        alertVc.addAction(failAction)
        present(alertVc, animated: true)
    }
    @IBAction func signUpBtn(_ sender: Any) {
        let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
           present(registerViewController, animated: true, completion: nil)
        
    }
}
