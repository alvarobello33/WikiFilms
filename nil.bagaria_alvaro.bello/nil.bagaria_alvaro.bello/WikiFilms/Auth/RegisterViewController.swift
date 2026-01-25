//
//  RegisterViewController.swift
//  WikiFilms
//
//  Created by Nil Bagaria Nofre on 20/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var regMsg: UILabel!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var repeatEmailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    @IBOutlet weak var regBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regMsg.text = NSLocalizedString("register_message", comment: "")
        repeatEmailField.placeholder = NSLocalizedString("repeat_email", comment: "")
        usernameField.placeholder = NSLocalizedString("username", comment: "")
        passwordField.placeholder = NSLocalizedString("password", comment: "")
        repeatPasswordField.placeholder = NSLocalizedString("repeat_password", comment: "")
        regBtn.setTitle(NSLocalizedString("register", comment: "") , for: .normal)



        // Do any additional setup after loading the view.
    }
    
    //FUNCIONALITAT REGISTRE USUARIS
    @IBAction func registerButton(_ sender: UIButton) {
        
        //llegim la info dels camps i comprovem que no estiguin buits
        guard
            let email = emailField.text, !email.isEmpty,
            let repeatEmail = repeatEmailField.text, !repeatEmail.isEmpty,
            let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let repeatPassword = repeatPasswordField.text, !repeatPassword.isEmpty
        else {
            //si hi ha algun dels camps buits mostrem alerta i sortim
            showAlert(title:NSLocalizedString("miss_info", comment: ""), message: NSLocalizedString("miss_info_fields", comment: ""))
            return
        }
        
        //Si el mail no es valid mostrem alerta i sortim
        if !isValidEmail(email) {
            showAlert(title: NSLocalizedString("invalid_mail", comment: ""), message: NSLocalizedString("mail_must_contain", comment: ""))
            return
        }
        
        //Comprovem que els dos mails siguin iguals
        if email != repeatEmail {
            showAlert(title: NSLocalizedString("missmatch_mail", comment: ""), message: NSLocalizedString("fields_not_match", comment: ""))
            return
        }
        
        //Si la password no compleix els criteris mostrem alerta i sortim
        if !isValidPassword(password) {
            showAlert(
                title: NSLocalizedString("invalid_psswd", comment: ""),
                message: NSLocalizedString("psswd_requirements", comment: ""))
            return
        }
        
        //Comprovem que les dues passwords siguin iguals
        if password != repeatPassword {
            showAlert(title:NSLocalizedString("missmatch_pswd", comment: ""), message: NSLocalizedString("pswd_fields_not_match", comment: ""))
            return
        }
        
        //Creem usuari a FirebaseAuth
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            //Error retornat per Firebase: email existent, password que no compleix...
            if error != nil {
                self.showAlert(title: NSLocalizedString("register_error", comment: ""), message: NSLocalizedString("register_error_firebase", comment: ""))
                return
            }
            
            //Agafem l'ID de l'usuari creat a Firebase (sera unic)
            guard let userID = authResult?.user.uid else {
                return
            }
            
            //Accedim a Firestore
            let database = Firestore.firestore()
            
            //Guardem les dades "extres": username (email tambe pq aixi ja el tindrem pel profile a "users" desde Firestore)
            database.collection("users").document(userID).setData(["username": username, "email": email]) { error in
                
                if error != nil {
                    self.showAlert(title: NSLocalizedString("db_error", comment: ""), message: NSLocalizedString("db_error_text", comment: ""))
                }
                
                else {
                    let successAlert = UIAlertController(title:NSLocalizedString("success_alert", comment: ""), message: NSLocalizedString("succes_login", comment: ""), preferredStyle: .alert)
                    
                    //Quan sha registrat correctament i saccepta lalerta, enviem a la pagina inicial per fer el login
                    let acceptAction = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default) { _ in
                        //Fem un pop per tornar a la vista anterior
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    successAlert.addAction(acceptAction)
                    self.present(successAlert, animated: true)
                }
            }
        }
    }
        
    //Funcio per validar email -> que contingui @ i .
    func isValidEmail(_ email: String) -> Bool {
        if email.contains("@") && email.contains(".") {
            return true
        }
        return false
    }
        
    //Funcio per validar password -> que contingui 6 caracters, 1 majuscula, 1 minuscula i 1 numero
    func isValidPassword(_ password: String) -> Bool {
            
        //Mirem q tingui 6 caracters
        if password.count < 6 {
            return false
        }
            
        //Mirem q tingui 1 majuscula, 1 minuscula i 1 numero
        let hasMajus = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasMinus = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
            
        if hasMajus && hasMinus && hasNumber {
            return true
        }
            
        return false
            
    }
        
    //Funcio per mostrar alertes al registre
    func showAlert(title: String, message: String) {
        let registerAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default)
        registerAlert.addAction(acceptAction)
            
        present(registerAlert, animated: true)
    }
}

