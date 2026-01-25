//
//  ProfileViewController.swift
//  WikiFilms
//
//  Created by user282659 on 12/23/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var currentEmailLabel: UILabel!
    
    @IBOutlet weak var changeEmailField: UITextField! //Ho canviem per username
    
    @IBOutlet weak var changePasswordField: UITextField!
    
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //botó de logout
        logoutButton.setTitle(NSLocalizedString("logout_buton", comment: ""), for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "DIN Condensed Bold", size: 20)
        logoutButton.setTitleColor(.white, for: .normal)
        
        //Carreguem les dades de lusuari actual
        loadUserData()
    }
    
    //Funcio per carregar les dades de lusuari
    func loadUserData() {
        
        //obtenim lusuari actual de FirebaseAuth
        guard let user = Auth.auth().currentUser else { return }
        
        //mostrem email actual
        currentEmailLabel.text = user.email
        
        //agafem el username de Firestore
        let database = Firestore.firestore()
        
        database.collection("users").document(user.uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.usernameLabel.text = data["username"] as? String
            }
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else { return }

        let newPassword = changePasswordField.text ?? ""
        let repeatPassword = repeatPasswordField.text ?? ""
        //eliminem espais en blanc i salts d linia del username
        let newUsername = changeEmailField.text?.trimmingCharacters(in:.whitespacesAndNewlines) ?? ""
        
        //USERNAME
        let database = Firestore.firestore()
        
        if !newUsername.isEmpty {
            
            database.collection("users").document(user.uid).updateData(["username": newUsername]) { error in
                    
                if error != nil {
                    self.showAlert(title: NSLocalizedString("profile_error", comment: ""), message: NSLocalizedString("username_update_error", comment: ""))
                    return
                }
                
                self.showAlert(title: NSLocalizedString("prof_success", comment: ""), message: NSLocalizedString("username_updated", comment: ""))
            }
        }
        

        //PASSWORD
        if !newPassword.isEmpty {

            if newPassword != repeatPassword {
                showAlert(title: NSLocalizedString("profile_pswd_error", comment: ""),message: NSLocalizedString("profile_pswd_not_match", comment: ""))
                return
            }

            if !isValidPassword(newPassword) {
                showAlert(title: NSLocalizedString("invalid_psswd", comment: ""), message: NSLocalizedString("psswd_requirements", comment: ""))
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let updtError = error {

                    let alert = UIAlertController(title: NSLocalizedString("session_expired", comment: ""), message: NSLocalizedString("login_required_to_update", comment: ""), preferredStyle: .alert)

                    let action = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default) { updtError in
                        self.forceLogoutAfterChange()
                    }

                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }

                let alert = UIAlertController(title: NSLocalizedString("prof_success", comment: ""), message: NSLocalizedString("login_again", comment: ""), preferredStyle: .alert)

                let action = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default) { updtError in
                    self.forceLogoutAfterChange()
                }

                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
        
    }
    
    //Boto per tancar sessio
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
            //tornem a la welcomeview descartant el tabbar
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(identifier: "WelcomeVC")
            
            welcomeVC.modalPresentationStyle = .fullScreen
            present(welcomeVC, animated: true)

        } catch {
            showAlert(title: NSLocalizedString("logout_error", comment: ""), message: NSLocalizedString("logout_error_text", comment: ""))
        }
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
    
    //Funcio per mostrar alertes
    func showAlert(title: String, message: String) {
        let saveChangesAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: NSLocalizedString("accept_alert", comment: ""), style: .default)
        saveChangesAlert.addAction(acceptAction)
        
        present(saveChangesAlert, animated: true)
    }
    
    func forceLogoutAfterChange() {
        try? Auth.auth().signOut()
        
        //tornem a la welcomeview descartant el tabbar
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(identifier: "WelcomeVC")
        
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true)
    }
}

