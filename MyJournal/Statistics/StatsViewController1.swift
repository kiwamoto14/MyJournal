//
//  StatsViewController1.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 7/18/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import UIKit
import Charts

class StatsViewController1: UIViewController {
    
    var fantastic = 0
    var good = 0
    var okay = 0
    var bad = 0
    var terrible = 0
    
    private var date: Date!
    var monthIndex = 0
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var moodChart: PieChartView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var fantasticDataEntry = PieChartDataEntry(value: 0)
    var goodDataEntry = PieChartDataEntry(value: 0)
    var okayDataEntry = PieChartDataEntry(value: 0)
    var badDataEntry = PieChartDataEntry(value: 0)
    var terribleDataEntry = PieChartDataEntry(value: 0)
    
    var numberofMoodEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nextButton.isEnabled = false
        //previousButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //default month
        date = Date()
        date = getMonth(date: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        let currentDate = formatter.string(from: date)
        dateTextField.text = currentDate
        
        
        moodChart.chartDescription?.text = ""
        findMonth()
        retrieveData()
        
        numberofMoodEntries = [fantasticDataEntry, goodDataEntry, okayDataEntry, badDataEntry, terribleDataEntry]
        updateChartData()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        monthIndex += 1
        dateTextField.text = formatter.string(from: MonthSections[monthIndex].month)
        
        if monthIndex == MonthSections.count - 1 {
            nextButton.isEnabled = false
        }
        
        retrieveData()
        
        numberofMoodEntries = [fantasticDataEntry, goodDataEntry, okayDataEntry, badDataEntry, terribleDataEntry]
        updateChartData()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        monthIndex -= 1
        dateTextField.text = formatter.string(from: MonthSections[monthIndex].month)
        
        if monthIndex == 0 {
            previousButton.isEnabled = false
        }
        
        retrieveData()
        
        numberofMoodEntries = [fantasticDataEntry, goodDataEntry, okayDataEntry, badDataEntry, terribleDataEntry]
        updateChartData()
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numberofMoodEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.purple]
        chartDataSet.colors = colors
        
        moodChart.data = chartData
    }
    
    func findMonth() {
        for x in 0..<MonthSections.count {
            if MonthSections[x].month == date {
                monthIndex = x
            }
        }
    }
    
    func retrieveData() {
        
        fantastic = 0
        good = 0
        okay = 0
        bad = 0
        terrible = 0
        
        if MonthSections.count == 0 {
            moodChart.centerText = "No Entries"
        }
        else {
            for entry in MonthSections[monthIndex].entries {
                if entry.mood == .fantastic {
                    fantastic += 1
                }
                else if entry.mood == .good {
                    good += 1
                }
                else if entry.mood == .okay {
                    okay += 1
                }
                else if entry.mood == .bad {
                    bad += 1
                }
                else if entry.mood == .terrible {
                    terrible += 1
                }
            }
            
            fantasticDataEntry.value = Double(fantastic)
            goodDataEntry.value = Double(good)
            okayDataEntry.value = Double(okay)
            badDataEntry.value = Double(bad)
            terribleDataEntry.value = Double(terrible)
            
            if fantasticDataEntry.value > 0 {
                fantasticDataEntry.label = "fantastic"
            }
            if goodDataEntry.value > 0 {
                goodDataEntry.label = "good"
            }
            if okayDataEntry.value > 0 {
                okayDataEntry.label = "okay"
            }
            if badDataEntry.value > 0 {
                badDataEntry.label = "bad"
            }
            if terribleDataEntry.value > 0 {
                terribleDataEntry.label = "terrible"
            }
            
        }
       
    }
    
    func setupButton() {
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
