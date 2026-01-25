//
//  LoginViewController.swift
//  WikiFilms
//
//  Created by Nil Bagaria Nofre 20/12/25.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginMsg: UILabel!
    
    //Instancia del camp email
    @IBOutlet weak var emailField: UITextField!
    
    //Instancia del camp password
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginMsg.text = NSLocalizedString("login_message", comment: "")
        passwordField.placeholder = NSLocalizedString("password", comment: "")
        // Do any additional setup after loading the view.
    }
    
    //Accio del button de login
    @IBAction func loginButton(_ sender: Any) {
        
        //Comprovem q els camps no estiguin buits
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            showAlert(title: NSLocalizedString("miss_info", comment: ""), message: NSLocalizedString("miss_info_text", comment: ""))
            return
        }
        
        //INICI DE SESSIO - FirebaseAuth
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
            //Si hi ha error (credencials incorrectes, usuari no existeix...)
            if error != nil {
                //Mostrem alerta derror
                self.showAlert(title: NSLocalizedString("login_error", comment: ""), message: NSLocalizedString("login_error_text", comment: ""))
                return
            }
            
            //Login Correcte
            print("Login successfull")
            
            //Ens desplacem a la pantalla del TabBar -> (HomeView)
            self.performSegue(withIdentifier: "loginToTabBarController", sender: nil)
        }
    }
    
    @IBAction func biometricLoginButton(_ sender: UIButton) {
        
        //Comprovem que existeixi un usuari autenticat prèviament, sino no deixem fer login biometric
        guard Auth.auth().currentUser != nil else {
            showAlert(title: NSLocalizedString("login_required", comment: ""), message: NSLocalizedString("login_required_text", comment: ""))
            return
        }
        
        //Biometria
        let context = LAContext()
                var error: NSError?
                
                //Comprovem si el dispositiu té biometria
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                    
                    let reason = NSLocalizedString("auth_reason", comment: "")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, AuthenticationError in
                        
                        DispatchQueue.main.async {
                            
                            if success {
                                //Si la biometria és corrrecta -> entrem
                                self.performSegue(withIdentifier: "loginToTabBarController", sender: nil)
                            } else {
                                self.showAlert(title: NSLocalizedString("auth_failed", comment: ""), message: NSLocalizedString("auth_failed_reason", comment: ""))
                            }
                        }
                    }
                } else {
                    //El dispositiu no té per fer biometria
                    showAlert(title: NSLocalizedString("unvailable", comment: ""), message: NSLocalizedString("biometric_not_available", comment: ""))
                }
    }
    
    
    //Funcio per mostrar alertes al login
    func showAlert(title: String, message: String) {
        let loginAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default)
        loginAlert.addAction(acceptAction)
        
        present(loginAlert, animated: true)
    }
}


