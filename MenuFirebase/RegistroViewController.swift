//
//  RegistroViewController.swift
//  MenuFirebase
//
//  Created by Josue Medina on 03/06/22.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController {

    @IBOutlet weak var correUsr: UITextField!
    
    @IBOutlet weak var contraseñaUsr: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func IniciarBtn(_ sender: UIButton) {
        if let email = correUsr.text, let password = contraseñaUsr.text{
            Auth.auth().createUser(withEmail: email, password: password){ resultado, error in
                //validar si hubo un error
                if let e = error{
                    print("Error al crear usuario en firebase: \(e.localizedDescription)")
                }else{
                    //se pudo crear
                    print("Usuario creado")
                    self.performSegue(withIdentifier: "registroMenu", sender: self)
                }
            }
        }
    }
    

}
