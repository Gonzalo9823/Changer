//
//  SignUpViewController.swift
//  Changer
//
//  Created by Gonzalo Caballero on 8/22/16.
//  Copyright © 2016 Gonzalo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import EZAlertController

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let dataBaseRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatpassword: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        loading.startAnimating()
        
        if password.text! == repeatpassword.text! {
            
            FIRAuth.auth()?.createUserWithEmail(mail.text!, password: password.text!, completion: { (user: FIRUser?, error: NSError?) in
                if error == nil {
                    print("Entro \(user?.email)")
                    
                    self.createNewUserOnDataBase(user)
                }
                else {
                    self.loading.stopAnimating()
                    print("Error \(error?.localizedDescription)")
                    
                    var mensajeDeError = ""
                    
                    switch error!.localizedDescription {
                    case "An internal error has occurred, print and inspect the error details for more information.":
                        mensajeDeError = "Por favor llena todos los campos."
                    default:
                        mensajeDeError = "Error"
                    }
                    
                    if error!.localizedDescription == "The email address is already in use by another account." {
                        mensajeDeError = "Este mail ya tiene una cuenta creada."
                    }
                    
                    EZAlertController.alert("Error", message: "\(mensajeDeError)", acceptMessage: "OK") { () -> () in
                        print("cliked OK")
                    }
                }
            })
            
        }
        
        else {
            loading.stopAnimating()
            EZAlertController.alert("Error", message: "Las contraseñas no son iguales")
        }
    }
    
    func createNewUserOnDataBase(user : FIRUser?) {
        let info = dataBaseRef.child("Users").child(user!.uid)
        let details = ["Nombre": nombre.text!, "Mail": mail.text!]
        info.setValue(details)
    }
}
