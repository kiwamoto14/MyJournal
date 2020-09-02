//
//  SecondViewController.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/13/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import UIKit

class AddTextViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var itemEntryTextView: UITextView?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    @IBAction func cancel(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
    @IBAction func saveContact(_ sender: Any) {

        if (itemEntryTextView?.text.isEmpty)! || itemEntryTextView?.text == "Type anything..."{
            print("No Data")

            let alert = UIAlertController(title: "Please Type Something", message: "Your entry was left blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in

                })

            self.present(alert, animated: true, completion: nil)

            }
        else {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            let currentDate = formatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            let currentTime = timeFormatter.string(from: date)

            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newEntry = Item(context: context)
            newEntry.name = itemEntryTextView?.text!
            newEntry.date = currentDate
            newEntry.time = currentTime

            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            dismiss(animated: true, completion: nil)

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        itemEntryTextView?.delegate = self

            // Do any additional setup after loading the view.
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }


        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = UIColor.black
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if (text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
}

