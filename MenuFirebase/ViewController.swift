//
//  ViewController.swift
//  MenuFirebase
//
//  Created by Josue Medina on 22/05/22.
//

import UIKit
import CLTypingLabel
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var mensajeBienvenidaLabel: CLTypingLabel!
    
    @IBOutlet weak var coreUsuario: UITextField!
    
    @IBOutlet weak var contraseñaUsuario: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mensajeBienvenidaLabel.text = "La Liga App"
        
        mensajeBienvenidaLabel.charInterval = 0.03
        
        mensajeBienvenidaLabel.onTypingAnimationFinished = {
            self.mensajeBienvenidaLabel.textColor = .black

        //
            // MARK: - Valida si esta la sesion guardada
                    let defaults = UserDefaults.standard
                    if let email = defaults.value(forKey: "email") as? String{
                        //utilizar segue para ir al HOME VC
                        print(email)
                        print("Se encontro la sesion guardada y se navega a HOME VC")
                        self.performSegue(withIdentifier: "loginMenu", sender: self)
                    }
            

        }
    }

    @IBAction func loginButton(_ sender: UIButton) {
        if let email = coreUsuario.text, let password = contraseñaUsuario.text{
            Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
                if let e = error{
                    print("Error al iniciar sesion \(e.localizedDescription)")
                }else{
                    print("Inicio exitoso")
                    self!.performSegue(withIdentifier: "loginMenu", sender: self)
                }
            }
        }
    }
}

