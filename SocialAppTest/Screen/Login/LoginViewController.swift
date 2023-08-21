//
//  LoginViewController.swift
//  SocialAppTest
//
//  Created by AsherFelix on 17/08/2023.
//

import UIKit
import Alamofire
import SwiftHEXColors
class LoginViewController: UIViewController {
    var passwordCheck = true
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var erroView: UIView!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordErro: UIImageView!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var erroLabel: UILabel!
    @IBOutlet weak var erroMessgae: UIImageView!
    @IBOutlet weak var erroBtn: UIButton!
    @IBOutlet weak var erroImage: UIImageView!
   
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmailPass()
        passwordPass()
        
       
    }
    private func setupEmailPass() {
        erroView.isHidden = true
        emailTF.backgroundColor = .white
        emailTF.layer.borderColor = UIColor.black.cgColor
        emailTF.placeholder = ""
        emailTF.keyboardType = .emailAddress
    }
    
    private func setupEmailErro() {
        emailTF.placeholder = "Input Email"
        erroView.isHidden = false
        emailTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
    }
    private func passwordPass() {
        passwordView.isHidden = true
        passwordTF.backgroundColor = .white
        passwordTF.layer.borderColor = UIColor.black.cgColor
        passwordTF.isSecureTextEntry = true
    }
    private func passwordEroo() {
        passwordView.isHidden = false
        passwordTF.backgroundColor = .cyan
        passwordTF.isSecureTextEntry = true
        passwordTF.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        passwordTF.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
    }
   
    
    @IBAction func showPassword(_ sender: Any) {
        passwordCheck.toggle()
        passwordTF.isSecureTextEntry = passwordCheck
       
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
       
        let email: String = emailTF.text ?? ""
        var emailPass = false
        if email.isEmpty {
            setupEmailErro()
        }else {
            setupEmailPass()
            emailPass = true
        }
        
        let password: String = passwordTF.text ?? ""
        var passwordDone =  false
        if password.isEmpty {
            passwordEroo()
        } else {
            passwordPass()
            passwordDone = true
        }
        
        let formPass = emailPass && passwordDone
        if formPass == true {
            callApiLogin()
        }
    }
    
    func loginFaild() {
        
    }
    func callApiLogin() {
        let domaim = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/login"
        AF.request(domaim,
                   method: .post,
                   parameters: [
                    "username": emailTF.text ?? "",
                    "password": passwordTF.text ?? ""
                   ],
                   encoder: JSONParameterEncoder.default
        )
        .validate(statusCode: 200..<300)
        .responseData { (afDataResponse: AFDataResponse<Data>) in
            switch afDataResponse.result {
            case . success(let data):
                print("Success")
                print(data)
                
                // chuyen kieu du lieu thanh Dictionary(JSON)
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String: Any] else {
                        return
                    }
                    print("json")
                    print(json)
                } catch {
                    print("erroMsg")
                }
            case .failure(let erro):
                print("failure")
                
                print(erro)
            }
        }
        
    }
    
}
