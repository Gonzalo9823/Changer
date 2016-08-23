//
//  LogInViewController.swift
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

class LogInViewController: UIViewController {
    
    let dataBaseRef = FIRDatabase.database().reference()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(sender: AnyObject) {
        loading.startAnimating()
        FIRAuth.auth()?.signInWithEmail(mail.text!, password: password.text!, completion: { (user: FIRUser?, error: NSError?) in
            if error == nil {
                print("Entro \(user?.email)")
                self.changeToIndex()
            }
            else {
                self.loading.stopAnimating()
                print("Error \(error?.localizedDescription)")
                
                var mensajeDeError = ""
                
                switch error!.localizedDescription {
                case "An internal error has occurred, print and inspect the error details for more information.":
                    mensajeDeError = "Por favor llena todos los campos."
                    
                case "The password is invalid or the user does not have a password.":
                    mensajeDeError = "La combinación mail contraseña no fue correcta."
                    
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
    
    func changeToIndex() {
        defaults.setBool(true, forKey: "logedIn")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyBoard.instantiateViewControllerWithIdentifier("tabBar") as! TabBarViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
    }
}
