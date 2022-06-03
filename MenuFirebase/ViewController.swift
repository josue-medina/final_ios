//
//  ViewController.swift
//  MenuFirebase
//
//  Created by marco rodriguez on 22/05/22.
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
        
        mensajeBienvenidaLabel.text = "Bienvenidos al Instituto Tecnologico de Morelia 🏫 "
        
        mensajeBienvenidaLabel.charInterval = 0.03
        
        mensajeBienvenidaLabel.onTypingAnimationFinished = {
            print("Mostrar algo!")
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

