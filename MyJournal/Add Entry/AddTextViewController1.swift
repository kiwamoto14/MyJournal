//
//  AddTextViewController1.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/15/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation
import UIKit

class AddTextViewController1: UIViewController {
    
    private var datePicker: UIDatePicker?
    @IBOutlet weak var dateTextField: UITextField!
    public var dateText = ""
    @IBOutlet var moodButtons: [UIButton]!
    @IBOutlet weak var continueButton: UIButton!
    var moodType: MoodType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //default date value
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let currentDate = formatter.string(from: date)
        dateTextField.text = currentDate
        
        //set up and disable continue button
        setupContinueButton()
        
        //set up date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        //set up done button
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0.224999994, green: 0.3549999893, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        toolBar.setItems([doneButton], animated: true)
        
        toolBar.isUserInteractionEnabled = true
        dateTextField.inputAccessoryView = toolBar
    }
    //prepare for a segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTextViewController2
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        vc.selectedDate = formatter.date(from: self.dateTextField.text!)
        vc.moodType = self.moodType
    }
    
    //action when user clicks cancel button
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // action when continue is tapped
    @IBAction func tappedContinue(_ sender: Any) {
        dateText = dateTextField.text!
        
        performSegue(withIdentifier: "goToSecond", sender: self)
    }
    
    @IBAction func moodTypeSelected(_ sender: UIButton) {
        continueButton.isEnabled = true
        continueButton.backgroundColor = .white
        continueButton.tintColor = .darkGray
        moodButtons.forEach {(button) in
            if button == sender {
                sender.tintColor = .orange
                moodType = MoodType.allCases[sender.tag]
            }
            else {
                button.tintColor = .blue
            }
        }
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // date picker selection
    @objc func dateChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    func setupContinueButton() {
        continueButton.backgroundColor = .systemGray5
        continueButton.tintColor = .systemGray5
        continueButton.layer.cornerRadius = 20
        continueButton.isEnabled = false
    }
}
