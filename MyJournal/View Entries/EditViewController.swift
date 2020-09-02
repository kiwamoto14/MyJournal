//
//  EditViewController.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/16/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditViewController: UIViewController {
    
    private var datePicker: UIDatePicker?
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var cellText = "" //inherited from tableview
    var dateText = "" //inherited from tableview
    var entryIndex: Int! //inherited from tableview
    var sectionIndex: Int! //inherited from tableview
    var imageName: String! //inherited from tableview
    
    @IBOutlet weak var moodView: UIButton!
    @IBOutlet var activitiesViews: [UIButton]!
    
    @IBAction func saveContact(_ sender: Any) {

        // if textbox is empty
        if  (textView?.text.isEmpty)! || textView?.text == "Type anything..."{
            print("No Data")

            let alert = UIAlertController(title: "Please Type Something", message: "Your entry was left blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in

            })

            self.present(alert, animated: true, completion: nil)

        }
    // if textbox isn't empty
        else {

            let formatter = DateFormatter()
            formatter.dateStyle = .long
        
            MonthSections[sectionIndex].entries[entryIndex].text = textView.text
            MonthSections[sectionIndex].entries[entryIndex].date = formatter.date(from: dateTextField.text!)!
        
            self.performSegue(withIdentifier: "dismissToTableView", sender: self)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        //show mood
        setupMood()
        
        //set up activities
        setupActivities()
        
        textView.layer.cornerRadius = 10
        
        //fill textfields
        dateTextField.text = dateText
        textView.text = cellText
        
        //set up date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
    
        //set up default datePicker date
        datePicker?.date = formatter.date(from: dateText)!
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        moodView.setImage( UIImage(imageLiteralResourceName: imageName), for: .normal
        )
        setupActivities()
    }
    
    //dismiss keyboard by clicking outside box
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function for done button
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //process date picker selection
    @objc func dateChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func editMood(_sender: UIButton) {
        performSegue(withIdentifier: "EditMood", sender: self)
    }
    
    
    @IBAction func editActivities(_ sender: UIButton) {
        performSegue(withIdentifier: "EditActivities", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditMoodView {
            let editMoodVC = segue.destination as! EditMoodView
            editMoodVC.mood = MonthSections[sectionIndex].entries[entryIndex].mood
            editMoodVC.entryIndex = self.entryIndex
            editMoodVC.sectionIndex = self.sectionIndex
            editMoodVC.instanceOfEditVC = self
        }
        else if segue.destination is EditActivitiesView {
            let editActivitiesVC = segue.destination as! EditActivitiesView
            editActivitiesVC.activities = MonthSections[sectionIndex].entries[entryIndex].activities
            editActivitiesVC.entryIndex = self.entryIndex
            editActivitiesVC.sectionIndex = self.sectionIndex
            editActivitiesVC.instanceOfEditVC = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func unwindToDisplayEditedEntry(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                print(self.imageName!)
                
                switch MonthSections[self.sectionIndex].entries[self.entryIndex].mood {
                case .terrible: self.imageName = "Terrible"
                case .bad: self.imageName = "Bad"
                case .okay: self.imageName = "Okay"
                case .good: self.imageName = "Good"
                case .fantastic: self.imageName = "Fantastic"
                }
                
                //show mood
                self.moodView.setImage( UIImage(imageLiteralResourceName: self.imageName), for: .normal
                )
                
                //set up activities
                self.setupActivities()
            }
        }
    }
    
    func setupMood() {
        moodView.setImage( UIImage(imageLiteralResourceName: imageName), for: .normal
        )
    }
    
    func setupActivities() {
        for button in activitiesViews {
            button.isEnabled = false
        }
        //assign array of activities into array of images
        for x in 0..<MonthSections[sectionIndex].entries[entryIndex].activities.count {
            activitiesViews[x].isEnabled = true
            switch MonthSections[sectionIndex].entries[entryIndex].activities[x] {
                
            case .eating:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Eating"), for: .normal)
                
            case .vacation:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Vacation"), for: .normal)
                
            case .driving:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Driving"), for: .normal)
                
            case .sports:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Sports"), for: .normal)
                
            case .work:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Work"), for: .normal)
                
            case .school:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "School"), for: .normal)
             
            case .friends:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Friends"), for: .normal)
         
            case .family:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Family"), for: .normal)
            
            case .relationship:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Love"), for: .normal)
        
            case .hobbies:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Hobbies"), for: .normal)
              
            case .swimming:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Swimming"), for: .normal)
         
            case .exercise:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Exercise"), for: .normal)
        
            case .shopping:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Shopping"), for: .normal)
          
            case .relaxing:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Relaxing"), for: .normal)
  
            case .doctor:
                activitiesViews[x].setImage(UIImage(imageLiteralResourceName: "Doctor"), for: .normal)
            
            
            }
        }
    }
}
