//
//  ViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var currentPageIndex = 0
    var scrollView: UIScrollView!
    var selectionBar: UIView!
    var toolBar: UIToolbar!
    var lastY:CGFloat = 0
    var data: Data = Data()
    var arrayScoresYear: [Scores]?
    var openSection = -1
    var tableViewResults = UITableView()
    var tableViewScores = UITableView()
    var tableViewScoresByYear = UITableView()
    var picker = UIPickerView()
    var year = 0
    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        super.viewDidLoad()
        self.data = self.data.dataTemp!
        arrayScoresYear = data.arrayGroupedScores.first?.arrayScores
        year = vInt(data.arrayGroupedScores.first?.groupName)
        setupViews()
        
    }
    
   

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if data.changed {
            
            setupViews()
            data.changed = false
        }
    }
    
    

    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "PokerlistName"
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "Menü", lBFunc: "settingsButtonAction:", rBTitle: "Add", rBFunc: "addButtonAction:")
        self.view.addSubview(navBar)
        
        // ToolBar
        toolBar = UIToolbar(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.frame.width, 44))
        self.view.addSubview(toolBar)
        setupButtons()
        
        // ScrollView
        let maxY = CGRectGetMaxY(toolBar.frame)
        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: maxY, width: self.view.frame.width, height: self.view.frame.height - maxY))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(4), height: scrollView.frame.height)
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for i in 0..<3 {
            
            let frame = CGRect(x: 0.0, y: 0.0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            // TableView
            let tableView = UITableView(frame: frame)
            tableView.tag = i
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor.whiteColor()
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
            tableView.frame.origin.x += CGFloat(i) * self.view.frame.width
            
            
            if (i == 2) {
                tableViewResults = tableView
            }
            
            if (i == 1) {
                
                tableView.frame.size.height -= 105
                tableViewScoresByYear = tableView
                
                // Pikcer Year
                picker = UIPickerView(frame: CGRectMake(0, scrollView.frame.height - 161, frame.width, 0))
                
                picker.frame.origin.x += CGFloat(i) * self.view.frame.width
                picker.backgroundColor = UIColor.lightGrayColor()
                picker.dataSource = self
                picker.delegate = self
                scrollView.addSubview(picker)
            }
            
            if (i == 0) {
                tableViewScores = tableView
            }
            
            scrollView.addSubview(tableView)

            
        }
        
        /// View for Stats
        let viewStats = UIView(frame: CGRect(x: 0.0, y: 0.0, width: scrollView.frame.width, height: scrollView.frame.height))
        viewStats.frame.origin.x += CGFloat(3) * self.view.frame.width
        viewStats.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(viewStats)
        
        self.view.addSubview(scrollView)
        
        var scrollToFrame = scrollView.frame
        scrollToFrame.origin = CGPointMake(scrollToFrame.width * CGFloat(currentPageIndex), 0)
        scrollView.scrollRectToVisible(scrollToFrame, animated: true)
    }
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            let tableScoresView = TableScoresViewController()
            switch currentPageIndex {
            case 0:
                tableScoresView.arrayScores = data.arrayScores
            case 1:
                 tableScoresView.arrayScores = arrayScoresYear
            default:
                return
            }
            
            tableScoresView.data = data
            self.presentViewController(tableScoresView, animated: true, completion: nil)
        }
    }
    
    // Switch Button
    func setupButtons() {
        
        var buttonText = ["Gesamt", "Alle", "Ergebnisse", "Statistik"]
        
        for i in 0..<4 {
            
            let button = UIButton(frame: CGRectMake(CGFloat(i) * (toolBar.frame.width / CGFloat(4)), 10, (toolBar.frame.width / CGFloat(4)), 34))
            
            button.tag = i
            button.addTarget(self, action: "tapSegmentButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(buttonText[i], forState:UIControlState.Normal)
            
            toolBar.addSubview(button)
            
        }
        self.setupSelector()
    }
    
    // Switch Button Action
    func tapSegmentButtonAction(button:UIButton) {
        
        var tempIndex = currentPageIndex
        if button.tag > tempIndex {
            for var i = tempIndex+1; i <= button.tag ; i++ {
                scrollView.scrollRectToVisible(CGRectMake(scrollView.frame.width*CGFloat(i), 0, scrollView.frame.width, scrollView.frame.height), animated: true)
            }
        }
        else if button.tag < tempIndex {
            for var i = tempIndex-1; i >= button.tag ; i-- {
                scrollView.scrollRectToVisible(CGRectMake(scrollView.frame.width*CGFloat(i), 0, scrollView.frame.width, scrollView.frame.height), animated: true)
            }
        }
    }
    
    // Einstellungen
    func settingsButtonAction(button: UIButton) {
        
        let settingsView = SettingsViewController()
        settingsView.data = data
        self.presentViewController(settingsView, animated: true, completion: nil)

    }
    
    // Neues Ergebnis
    func addButtonAction(button: UIButton) {
        let resultsView = ResultsViewController()
        resultsView.data = data
        self.presentViewController(resultsView, animated: true, completion: nil)
    }
    
    // Switch Selector
    func setupSelector() {
        selectionBar = UIView(frame: CGRectMake(0, 40, (toolBar.frame.width / CGFloat(4)), 4))
        selectionBar.backgroundColor = UIColor.greenColor()
        selectionBar.alpha = 0.8
        toolBar.addSubview(selectionBar)
        
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numberOfSectionsInTableView = 1
        
        switch tableView.tag {
        case 0:
            numberOfSectionsInTableView = 1
        case 1:
            numberOfSectionsInTableView = 1
        case 2:
            numberOfSectionsInTableView = data.arrayGroupedResults.count
        default:
            numberOfSectionsInTableView = 1
        }
        
        return numberOfSectionsInTableView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height = CGFloat()
        
        switch tableView.tag {
        case 0:
            height = 44
        case 1:
            height = 44
        case 2:
            height = 44
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView.tag {
        case 0, 1:
            
            let view = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 44))
            view.backgroundColor = UIColor.whiteColor()
            let viewBorder = UIView(frame: CGRectMake(0, 42, tableView.frame.width, 2))
            viewBorder.backgroundColor = UIColor.blackColor()
            view.addSubview(viewBorder)
            
            let sizeLabelName: CGFloat = self.view.frame.width - (4 * 10) - 40 - 100 - 20
            
            let labelPos = UILabel(frame: CGRectMake(10, 0, 40, view.frame.height))
            labelPos.textAlignment = NSTextAlignment.Center
            labelPos.font = .boldSystemFontOfSize(16.0)
            labelPos.text = "Pos."
            
            let labelName = UILabel(frame: CGRectMake(CGRectGetMaxX(labelPos.frame) + 10, 0, sizeLabelName, view.frame.height))
            labelName.font = .boldSystemFontOfSize(16.0)
            labelName.text = "Name"
            
            let labelRatio = UILabel(frame: CGRectMake(CGRectGetMaxX(labelName.frame) + 10, 0, 100, view.frame.height))
            labelRatio.textAlignment = .Right
            labelRatio.font = .boldSystemFontOfSize(16.0)
            labelRatio.text = "Verhältnis"
            
            view.addSubview(labelPos)
            view.addSubview(labelName)
            view.addSubview(labelRatio)
            
            return view
            
        case 2:
            let btnHeader = UIButton(frame: CGRectMake(0, 0, tableView.frame.width, 44))
            let oRES = data.arrayGroupedResults[section].first!
            
            btnHeader.tag = section
            tableViewResults = tableView
            btnHeader.addTarget(self, action: "tapSectionButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            btnHeader.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnHeader.setTitle(oRES.dateString, forState:UIControlState.Normal)
            btnHeader.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            btnHeader.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            btnHeader.backgroundColor = UIColor.lightGrayColor()
            return btnHeader

        default:
            return nil
        }

        
    }
    
    func tapSectionButtonAction(button: UIButton) {
        
        if (openSection == button.tag) {
            openSection = -1
        } else {
            openSection = button.tag
        }
        
        for view in self.scrollView.subviews {
            if view.tag == 2 {
                
                UIView.transitionWithView(view as! UIView, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    
                    view.setContentOffset(CGPointMake(0, CGFloat(button.tag)*44.00), animated: true)
                    view.reloadData()

                    }, completion: { (fininshed: Bool) -> () in
                        
                })
            }
        }
        
    }

    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var oRES = data.arrayGroupedResults[section].first!
        var header = ""
        
        switch tableView.tag {
        case 0:
            header = ""
        case 1:
            header = ""
        case 2:
            header = oRES.dateString
        default:
            header = ""
        }
        
        return header
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        switch tableView.tag {
        case 0:
            numberOfRows = data.arrayScores.count
        case 1:
            numberOfRows = vInt(arrayScoresYear?.count)
        case 2:
            numberOfRows = (section == openSection) ? data.arrayGroupedResults[section].count : 0
        default:
            numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        // Cell Layout
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            //cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
            
            switch tableView.tag {
            case 0, 1:
                
                let sizeLabelName: CGFloat = self.view.frame.width - (4 * 10) - 40 - 100 - 20
                
                let labelPos = UILabel(frame: CGRectMake(10, 0, 40, cell!.frame.height))
                labelPos.tag = 1
                labelPos.textAlignment = .Right
                
                let labelName = UILabel(frame: CGRectMake(CGRectGetMaxX(labelPos.frame) + 10, 0, sizeLabelName, cell!.frame.height))
                labelName.tag = 2
                
                let labelRatio = UILabel(frame: CGRectMake(CGRectGetMaxX(labelName.frame) + 10, 0, 100, cell!.frame.height))
                labelRatio.tag = 3
                labelRatio.textAlignment = .Right
                
                cell!.addSubview(labelPos)
                cell!.addSubview(labelName)
                cell!.addSubview(labelRatio)
                
            case 2:
                
                cell?.selectionStyle = .None

            default:
                println("TableView ohne Tag")
            }

        }
        
        // Cell Daten
        switch tableView.tag {
        case 0:
            
            let oSCO = data.arrayScores[indexPath.row]
     
            (cell!.viewWithTag(1) as! UILabel).text = vString(indexPath.row + 1)
            (cell!.viewWithTag(2) as! UILabel).text = oSCO.linkedPerson(self.data.arrayPersons)?.name
            (cell!.viewWithTag(3) as! UILabel).text = String(format: "%.2f", vDouble(oSCO.ratio))

            for i in 1...3 {
                (cell!.viewWithTag(i) as! UILabel).font = oSCO.linkedPerson(self.data.arrayPersons)!.me ? .boldSystemFontOfSize(16.0) : .systemFontOfSize(16.0)
            }

        case 1:
            
            let oSCO = arrayScoresYear?[indexPath.row]
            
            (cell!.viewWithTag(1) as! UILabel).text = vString(indexPath.row + 1)
            (cell!.viewWithTag(2) as! UILabel).text = oSCO!.linkedPerson(self.data.arrayPersons)?.name
            (cell!.viewWithTag(3) as! UILabel).text = String(format: "%.2f", vDouble(oSCO?.ratio))
            
            for i in 1...3 {
                (cell!.viewWithTag(i) as! UILabel).font = oSCO!.linkedPerson(self.data.arrayPersons)!.me ? .boldSystemFontOfSize(16.0) : .systemFontOfSize(16.0)
            }
            
        case 2:
            
            let oRES = data.arrayGroupedResults[indexPath.section][indexPath.row]
            
            let ratio = String(format: "%.2f", vDouble(oRES.ratio))
            let valueIn = String(format: "%.2f", vDouble(oRES.moneyIn))
            let valueOut = String(format: "%.2f", vDouble(oRES.moneyOut))
            cell?.textLabel?.text = "\(oRES.linkedPerson(self.data.arrayPersons)!.name) - \(ratio)%"
            cell?.detailTextLabel?.text = "In: \(valueIn) Out: \(valueOut)"
            
        default:
            println("TableView ohne Tag")
        }
        
        return cell!
       
    }
    
    // Zeilen Klick - Spieler Statistik aurufen
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var oSCO: Scores?
        switch tableView.tag {
        case 0:
            oSCO = data.arrayScores[indexPath.row]
        case 1:
            oSCO = arrayScoresYear?[indexPath.row]
        default:
            oSCO = nil
        }

        
        if tableView.tag == 0 || tableView.tag == 1 {
            let personsStatsView = PersonsStatsViewController()
            personsStatsView.data = data
            personsStatsView.PER_ID = oSCO!.PER_ID
            personsStatsView.year = (tableView.tag  == 1) ? year : 0
            personsStatsView.oSCO = oSCO
            self.presentViewController(personsStatsView, animated: true, completion: nil)
        }
    }
    
    // MARK: - PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data.arrayGroupedScores[row].groupName
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.arrayGroupedScores.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        arrayScoresYear = data.arrayGroupedScores[row].arrayScores
        year = vInt(data.arrayGroupedScores[row].groupName)
        tableViewScoresByYear.reloadData()
    }
    
    // MARK: - ScrollView
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y != 0 {
            lastY = scrollView.contentOffset.y
        }
        
        if scrollView.contentOffset.y != 0 || (scrollView.contentOffset.y == 0 && scrollView.contentOffset.x == 0) {
            return
        }
        
        var xFromCenter:CGFloat = (self.view.frame.size.width - scrollView.contentOffset.x) / CGFloat(4)
        var xCoor:CGFloat = selectionBar.frame.size.width
        
        selectionBar.frame = CGRectMake(xCoor - xFromCenter, selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        currentPageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if lastY == 0 {
            currentPageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        } else {
            lastY = 0
        }
    }
    
    
}





