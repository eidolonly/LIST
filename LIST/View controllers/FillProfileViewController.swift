//
//  FillProfileViewController.swift
//  LIST
//
//  Created by 蔡雨倩 on 27/05/2018.
//  Copyright © 2018 蔡雨倩. All rights reserved.
//

import UIKit
import FirebaseAuth

class FillProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var user: LISTUser!
    
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var mottoField: UITextField!
    
    let picker = UIDatePicker()
    
    let genderPicker = UIPickerView()
    let genders = ["Male", "Female"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        nameField.delegate = self
        dateField.delegate = self
        genderField.delegate = self
        mottoField.delegate = self
        
        genderField.inputView = genderPicker
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let _ = user else { return }
            self.user = LISTUser()
        }
    }

    // MARK: Set the date picker with a tool bar
    func createDatePicker(){
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
        user.birthDate = dateString
    }
    
    // MARK: Set the gender picker
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genders[row]
        genderPicker.resignFirstResponder()
        if let text = genderField.text{
            user.gender = text
        }
    }
    
    // MARK: I'm ready tapped
    @IBAction func imReadyTapped(_ sender: UIButton) {
        if let text = nameField.text{
            user.userName = text
        }
        if let text = mottoField.text{
            user.motto = text
        }
        
        self.performSegue(withIdentifier: "goToHomePageAfterSignUp", sender: self)
    }
    
    // MARK: Dismiss the keyboard
    // when touching outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
