//
//  PersonsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 09.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class PersonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: Data!
    var tableView = UITableView()
    var alert: AlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Spieler"
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "Zurück", lBFunc: "backButtonAction:", rBTitle: "Neu", rBFunc: "newPersonButtonAction:")
        self.view.addSubview(navBar)
        
        // TableView
        tableView = UITableView(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.frame.width, self.view.frame.height - CGRectGetMaxY(navBar.frame)))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
    }
    
    func newPersonButtonAction(button: UIButton) {
        
        alert = AlertViewController()
        alert!.info(self, title: "Neuer Spieler", text: "Neuen Spieler hinzufügen", placeholder: "Name", buttonText: "Speichern",  cancelButtonText: "Abbrechen")
        alert!.containerView.frame.origin.y = 100
        alert!.addAction {
            
            if self.alert!.textField1.text == "" {
                self.alert!.textField1.layer.borderColor = UIColor.redColor().CGColor
            }
            else {
                let oPER = Persons(name: self.alert!.textField1.text)
                oPER.addPersonWS()
                self.data.arrayPersons.append(oPER)
                self.data.sortArrayPersons()
                self.tableView.reloadData()
                self.alert!.closeView(false)
            }
        }
    }
    
    func backButtonAction(button: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.arrayPersons.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        let oPER = data.arrayPersons[indexPath.row]
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell!.selectionStyle = .None
        }
        
        cell!.textLabel?.text = oPER.name
        
        return cell!
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let oPER = data.arrayPersons[indexPath.row]
        
        alert = AlertViewController()
        alert!.info(self, title: "Spieler bearbeiten", text: "Spieler \(oPER.name) bearbeiten", placeholder: "Name", buttonText: "Speichern",  cancelButtonText: "Abbrechen")
        
        alert!.addAction {
            
            if self.alert!.textField1.text == "" {
                self.alert!.textField1.layer.borderColor = UIColor.redColor().CGColor
            }
            else {
                oPER.name = self.alert!.textField1.text
                oPER.changed = NSDate()
                oPER.updatePersonWS()
                self.data.arrayPersons[indexPath.row] = oPER
                self.data.sortArrayPersons()
                self.tableView.reloadData()
                self.alert!.closeView(false)
            }
        }
        
    }
    
}
