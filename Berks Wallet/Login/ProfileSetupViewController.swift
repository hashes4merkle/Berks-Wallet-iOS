//
//  ProfileSetupViewController.swift
//  Berks Wallet
//
//  Created by Deverick Simpson on 12/24/18.
//  Copyright © 2018 ApolloLabs. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import PhoneNumberKit

class ProfileSetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let db_api = Data_Access()
    
    @IBOutlet weak var phone: PhoneNumberTextField!
    @IBOutlet weak var userbirthday: UIDatePicker!
    @IBOutlet weak var barberMenu: UIPickerView!

    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //BarberList: Number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("Count Value for picker: \(db_api.retCount())")
        return db_api.retCount()
    }
    
    //BarberList: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return pickerData[row]
        return db_api.retBarberFromIdx(value: row)
    }
    
    //Function completion handler for BarberList
    func countHandler(value: Int) {
        print("Function completion handler count value: \(db_api.retCount())")
    }
    
    //Function completion handler for BarberList
    func barberHandler() {
        print("Function printing current barber list:")
        db_api.printBarberArray()
        // Connect barber list dataset:
        barberMenu.delegate = self
        barberMenu.dataSource = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phone.becomeFirstResponder()
        userbirthday.setValue(UIColor.white, forKeyPath: "textColor")
        userbirthday.setValue(false, forKey: "highlightsToday")
        
        //Async process to build barber list
        db_api.popBarberCount(completion: countHandler)
        db_api.buildAllBarbersArray(completion: barberHandler)
        
        //DB Check
        //db_api.uploadAda()
    
    
        // Do any additional setup after loading the view, typically from a nib.


    }
    
    override func viewDidAppear(_ animated: Bool){
//        super.viewDidAppear(animated)
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "home", sender: nil)
//        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        var dateLabel = ""
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: userbirthday.date)
        //dateLabel.text = strDate
        print("\(strDate) is the date")
    }

    
    
    func saveProfile(){
        
    }

    @IBAction func submitProfile(_ sender: Any) {
        //Here we want to validate the user data input and submit to the database if no duplicates exist.   Some things to consider.  Do we need the phone number??  There should be apis to pull the # from rthe device but doesnt seem to exist.  Not exporting that service to to cost factors.  Will have to validate user phone with 2fa text and auto generated code.
        
        //Load barber Data from DB
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            let user = Auth.auth().currentUser
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
                //let photoURL = user.photoURL
                //let phoneNumber = user.phoneNumber
                //getting input from Text Field
                
                db_api.parsePhone(phoneNum: phone.text ?? "")
                if db_api.isValidEmail(testStr: email!){
                    let resp = db_api.saveUserProfile(firstName: first_name.text!, lastName: last_name.text!, phone: phone.text ?? "", email: email!, pBarber: "Cory77", birthday: 121 )
                    print("Profile DB response value is: \(resp)")
//                    self.performSegue(withIdentifier: "signupToHome", sender: self)[cgxvjbg
                }
                else{
                    print("invalide EmailID")
                }
            }
        } else {
            // No user is signed in.
            // Kick the user out
            // ...
        }
    }
    

    


}

