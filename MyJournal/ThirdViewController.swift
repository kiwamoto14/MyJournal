//
//  SecondViewController.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/13/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    func setupButton() {
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }


}

