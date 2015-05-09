//
//  PersonsStatsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 25.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit
import JawBone

class PersonsStatsViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {

    var data: Data!
    var year: Int = 0
    var PER_ID: Int = 0
    var oSCO: Scores?
    var lineChart = JBLineChartView()
    var chartTextLabel: UILabel!
    
    var chartLegend: [String] = []
    var chartData: [Int] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for oGSCO in data.arrayGroupedScores.reverse() {
            chartLegend.append(oGSCO.groupName)
            
            var dataValue = 0
            if let oSCO = oGSCO.arrayScores.filter( { $0.PER_ID == self.PER_ID } ).first {
                dataValue = data.arrayPersons.count - oSCO.position
            }
            
            chartData.append(dataValue)
        }
        
        setupViews()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Statistik"
        
        if let oPER: Persons = self.data.arrayPersons.filter( { $0.id == self.PER_ID } ).first {
            let header = (year == 0) ? "Gesamt" : vString(year)
            title = "Statistik \(oPER.name) \(header)"
        }
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "back", lBFunc: "backButtonAction:")
        self.view.addSubview(navBar)
        
        // Position
        let labelPos = UILabel(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame) + 10, self.view.frame.width, 34))
        labelPos.font = UIFont.boldSystemFontOfSize(20.0)
        labelPos.textAlignment = .Center
        labelPos.text = "Position: \(oSCO!.position)"
        self.view.addSubview(labelPos)
        
        
        // Spiele
        let labelGames = UILabel(frame: CGRectMake(0, CGRectGetMaxY(labelPos.frame), self.view.frame.width, 20))
        labelGames.font = UIFont.boldSystemFontOfSize(16.0)
        labelGames.textAlignment = .Center
        labelGames.text = "Spiele: \(oSCO!.games)"
        self.view.addSubview(labelGames)
        
        // Verhältnis
        let labelRatio = UILabel(frame: CGRectMake(0, CGRectGetMaxY(labelGames.frame), self.view.frame.width, 34))
        labelRatio.textAlignment = .Center
        let ratio = String(format: "%.2f", vDouble(oSCO?.ratio))
        let win = String(format: "%.2f", vDouble(oSCO!.moneyOut-oSCO!.moneyIn))
        labelRatio.text = "Verhältnis: \(ratio)%      G/V: \(win)€"
        self.view.addSubview(labelRatio)
        
        // Ein/Aus
        let labelInOut = UILabel(frame: CGRectMake(0, CGRectGetMaxY(labelRatio.frame), self.view.frame.width, 34))
        labelInOut.textAlignment = .Center
        let valueIn = String(format: "%.2f", vDouble(oSCO?.moneyIn))
        let valueOut = String(format: "%.2f", vDouble(oSCO!.moneyOut))
        labelInOut.text = "Ein: \(valueIn)€      Aus: \(valueOut)€"
        self.view.addSubview(labelInOut)
        
        // Stats Object
        lineChart.frame = CGRectMake(10, CGRectGetMaxY(labelInOut.frame) + 100, self.view.frame.width - 20, self.view.frame.height - CGRectGetMaxY(labelInOut.frame) - 130)
        lineChart.backgroundColor = UIColor.darkGrayColor()
        lineChart.delegate = self
        lineChart.dataSource = self
        lineChart.minimumValue = 1
        lineChart.maximumValue = CGFloat(data.arrayPersons.count)
        lineChart.reloadData()
        
        lineChart.setState(JBChartViewState.Expanded, animated: false)

        self.view.addSubview(lineChart)
        
        var footerView = UIView(frame: CGRectMake(0, 0, lineChart.frame.width, 16))
        
        var footer1 = UILabel(frame: CGRectMake(5, 0, lineChart.frame.width/2 - 8, 16))
        footer1.textColor = UIColor.lightGrayColor()
        footer1.text = "\(chartLegend[0])"
        
        var footer2 = UILabel(frame: CGRectMake(lineChart.frame.width/2 - 5, 0, lineChart.frame.width/2 - 5, 16))
        footer2.textColor = UIColor.lightGrayColor()
        footer2.text = "\(chartLegend[chartLegend.count - 1])"
        footer2.textAlignment = NSTextAlignment.Right
        
        footerView.addSubview(footer1)
        footerView.addSubview(footer2)
        
        var header = UILabel(frame: CGRectMake(0, 0, lineChart.frame.width, 50))
        header.textColor = UIColor.blackColor()
        header.backgroundColor = UIColor.whiteColor()
        header.font = UIFont.systemFontOfSize(24)
        header.text = "Jährliche Position"
        header.textAlignment = NSTextAlignment.Center
        
        lineChart.footerView = footerView
        lineChart.headerView = header

        chartTextLabel = UILabel(frame: CGRectMake(10, CGRectGetMaxY(lineChart.frame), lineChart.frame.width, 20))
        chartTextLabel.backgroundColor = UIColor.darkGrayColor()
        chartTextLabel.textColor = UIColor.lightGrayColor()
        chartTextLabel.textAlignment = .Center
        
        self.view.addSubview(chartTextLabel)
        
    }
    
    
    // MARK: - Line ChartView
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if (lineIndex == 0) {
            return UInt(chartData.count)
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if (lineIndex == 0) {
            return CGFloat(chartData[vInt(horizontalIndex)])
        }
        
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if (lineIndex == 0) {
            return UIColor.lightGrayColor()
        }
        
        return UIColor.lightGrayColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.lightGrayColor()
    }
    
   func lineChartView(lineChartView: JBLineChartView!, dotViewAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIView! {
        let view = UIView(frame: CGRectMake(0, 0, 20, 20))
        view.backgroundColor = UIColor.lightGrayColor()
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
    
        let label = UILabel(frame: CGRectMake(0, 0, 20, 20))
        label.text = (chartData[vInt(horizontalIndex)] == 0) ? "0" : vString(data.arrayPersons.count - chartData[vInt(horizontalIndex)])
        label.textAlignment = .Center
        label.font = .systemFontOfSize(10.0)
        view.addSubview(label)
    
        return view
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        if (lineIndex == 0) {
            let data = chartData[vInt(horizontalIndex)] == 0 ? 0 : self.data.arrayPersons.count - chartData[vInt(horizontalIndex)]
            let key = chartLegend[vInt(horizontalIndex)]
            chartTextLabel.text = "\(key): \(data)"
        }
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        chartTextLabel.text = ""
    }
    
    func lineChartView(lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.clearColor()
    }
    
    
    // MARK: - BarButton Events
    // Zurück
    func backButtonAction(button: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}