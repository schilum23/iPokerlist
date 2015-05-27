//
//  TableStatsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 06.04.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class TableScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data: Data!
    var year: Int = 0
    var PER_ID: Int = 0
    var arrayScores: [Scores]?

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setupViews()
    }
    
    // Oriantation change
    func rotated()
    {
        if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Help Functions
    func setupViews() {
            
        // TableView
        let tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
            
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayScores!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 46
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 44))
        view.backgroundColor = UIColor.whiteColor()
        let viewBorder = UIView(frame: CGRectMake(0, 42, tableView.frame.width, 2))
        viewBorder.backgroundColor = UIColor.blackColor()
        view.addSubview(viewBorder)
            
        let sizeLabelName: CGFloat = self.view.frame.width - 58 - (90 * 5) - 30
            
        let labelPos = UILabel(frame: CGRectMake(0, 0, 58, view.frame.height))
        labelPos.textAlignment = NSTextAlignment.Center
        labelPos.font = .boldSystemFontOfSize(16.0)
        labelPos.text = "Pos."
            
        let labelName = UILabel(frame: CGRectMake(CGRectGetMaxX(labelPos.frame) + 10, 0, sizeLabelName, view.frame.height))
        labelName.font = .boldSystemFontOfSize(16.0)
        labelName.text = "Name"
            
        let labelRatio = UILabel(frame: CGRectMake(CGRectGetMaxX(labelName.frame) + 10, 0, 80, view.frame.height))
        labelRatio.textAlignment = .Right
        labelRatio.font = .boldSystemFontOfSize(16.0)
        labelRatio.text = "Verhältnis"
        
        let labelWin = UILabel(frame: CGRectMake(CGRectGetMaxX(labelRatio.frame) + 10, 0, 80, view.frame.height))
        labelWin.textAlignment = .Right
        labelWin.font = .boldSystemFontOfSize(16.0)
        labelWin.text = "G/V"
        
        let labelIn = UILabel(frame: CGRectMake(CGRectGetMaxX(labelWin.frame) + 10, 0, 80, view.frame.height))
        labelIn.textAlignment = .Right
        labelIn.font = .boldSystemFontOfSize(16.0)
        labelIn.text = "Ein"
        
        let labelOut = UILabel(frame: CGRectMake(CGRectGetMaxX(labelIn.frame) + 10, 0, 80, view.frame.height))
        labelOut.textAlignment = .Right
        labelOut.font = .boldSystemFontOfSize(16.0)
        labelOut.text = "Aus"
        
        let labelGames = UILabel(frame: CGRectMake(CGRectGetMaxX(labelOut.frame) + 10, 0, 80, view.frame.height))
        labelGames.textAlignment = .Right
        labelGames.font = .boldSystemFontOfSize(16.0)
        labelGames.text = "Spiele"
            
        view.addSubview(labelPos)
        view.addSubview(labelName)
        view.addSubview(labelRatio)
        view.addSubview(labelWin)
        view.addSubview(labelIn)
        view.addSubview(labelOut)
        view.addSubview(labelGames)
        
        return view
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        // Cell Layout
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            
            let sizeLabelName: CGFloat = self.view.frame.width - 58 - (90 * 5) - 30
            
            let labelPos = UILabel(frame: CGRectMake(0, 0, 30, cell!.frame.height))
            labelPos.tag = 1
            labelPos.textAlignment = .Right
            labelPos.font = .boldSystemFontOfSize(16.0)
            
            let labelLastPos = UILabel(frame: CGRectMake(33, 0, 25, cell!.frame.height))
            labelLastPos.tag = 2
            labelLastPos.textAlignment = .Left
            labelLastPos.font = .boldSystemFontOfSize(10.0)
            
            let labelName = UILabel(frame: CGRectMake(CGRectGetMaxX(labelLastPos.frame) + 10, 0, sizeLabelName, cell!.frame.height))
            labelName.tag = 3
            labelName.font = .boldSystemFontOfSize(16.0)
            
            let labelRatio = UILabel(frame: CGRectMake(CGRectGetMaxX(labelName.frame) + 10, 0, 80, cell!.frame.height))
            labelRatio.tag = 4
            labelRatio.textAlignment = .Right
            labelRatio.font = .boldSystemFontOfSize(16.0)
            
            let labelWin = UILabel(frame: CGRectMake(CGRectGetMaxX(labelRatio.frame) + 10, 0, 80, cell!.frame.height))
            labelWin.tag = 5
            labelWin.textAlignment = .Right
            labelWin.font = .boldSystemFontOfSize(16.0)
            
            let labelIn = UILabel(frame: CGRectMake(CGRectGetMaxX(labelWin.frame) + 10, 0, 80, cell!.frame.height))
            labelIn.tag = 6
            labelIn.textAlignment = .Right
            labelIn.font = .boldSystemFontOfSize(16.0)
            
            let labelOut = UILabel(frame: CGRectMake(CGRectGetMaxX(labelIn.frame) + 10, 0, 80, cell!.frame.height))
            labelOut.tag = 7
            labelOut.textAlignment = .Right
            labelOut.font = .boldSystemFontOfSize(16.0)
            
            let labelGames = UILabel(frame: CGRectMake(CGRectGetMaxX(labelOut.frame) + 10, 0, 80, cell!.frame.height))
            labelGames.tag = 8
            labelGames.textAlignment = .Right
            labelGames.font = .boldSystemFontOfSize(16.0)
            
            cell!.addSubview(labelPos)
            cell!.addSubview(labelLastPos)
            cell!.addSubview(labelName)
            cell!.addSubview(labelRatio)
            cell!.addSubview(labelWin)
            cell!.addSubview(labelIn)
            cell!.addSubview(labelOut)
            cell!.addSubview(labelGames)
            
            if indexPath.row % 2 == 0 {
                cell!.backgroundColor = UIColorFromHex(0x3498db, alpha: 0.5)
            } else {
                cell!.backgroundColor = UIColor.whiteColor()
            }

        }
        
        let oSCO = arrayScores![indexPath.row]
            
        (cell!.viewWithTag(1) as! UILabel).text = vString(oSCO.position)
        (cell!.viewWithTag(2) as! UILabel).text = "(\(vString(oSCO.lastPosition)))"
        (cell!.viewWithTag(3) as! UILabel).text = oSCO.linkedPerson(self.data.arrayPersons)!.name
        (cell!.viewWithTag(4) as! UILabel).text = String(format: "%.2f", vDouble(oSCO.ratio))
        (cell!.viewWithTag(5) as! UILabel).text = String(format: "%.2f", vDouble(oSCO.moneyOut - oSCO.moneyIn))
        (cell!.viewWithTag(6) as! UILabel).text = String(format: "%.2f", vDouble(oSCO.moneyIn))
        (cell!.viewWithTag(7) as! UILabel).text = String(format: "%.2f", vDouble(oSCO.moneyOut))
        (cell!.viewWithTag(8) as! UILabel).text = vString(oSCO.games)

        for i in 1...8 {
            let size: CGFloat = i == 2 ? 10.00 : 16.00
            (cell!.viewWithTag(i) as! UILabel).font = oSCO.linkedPerson(self.data.arrayPersons)!.me ? .boldSystemFontOfSize(size) : .systemFontOfSize(size)
        }
 
        return cell!
        
    }
  
}
