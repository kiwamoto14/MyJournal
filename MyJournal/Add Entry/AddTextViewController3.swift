
//  AddTextViewController.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/13/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import UIKit
import CoreData

class AddTextViewController3: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var selectedDate: Date! //inherited from datePicker in AddTextViewController1
    var moodType: MoodType!
    var activities: [Activities] = [] //inherited from activities in AddTextViewController2

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var itemEntryTextView: UITextView?
    
    //action when user clicks save
    @IBAction func saveContact(_ sender: Any) {

        // if textbox is empty
        if  (itemEntryTextView?.text.isEmpty)! || itemEntryTextView?.text == "Add notes..."{
            print("No Data")

            let alert = UIAlertController(title: "Please Type Something", message: "Your entry was left blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in

                })

            self.present(alert, animated: true, completion: nil)

            }
        // if textbox isn't empty
        else {
            //add information to entity
            let entryText = itemEntryTextView?.text!
            
            //initialize new Entry
            let newData = Entry(id: UUID(), date: selectedDate, text: entryText!, mood: moodType, activities: activities)
            
            //add it to array of monthsections
            EntryFunctions.addEntry(entry: newData)
            
           MonthSections.sort()
            
            
            //dismiss entry modal popup
            self.performSegue(withIdentifier: "dismissToTableView", sender: self)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        itemEntryTextView?.delegate = self
        
        itemEntryTextView?.layer.cornerRadius = 10
        
        //Title for Navigation Bar
        self.navigationItem.title = "Entry"
        
        //set up done button
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0.224999994, green: 0.3549999893, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) //space for right alignment
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        toolBar.setItems([flexible, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        itemEntryTextView?.inputAccessoryView = toolBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMonth(date: Date) -> Date{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //action when user clicks cancel
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupSaveButton() {
        saveButton.backgroundColor = .white
        saveButton.layer.cornerRadius = 20
    }
    
}


