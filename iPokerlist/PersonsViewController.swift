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
    var customIcon = UIImage(named: "lightbulb")
    
    // MARK: - Init / Coder
    override func viewDidLoad() {
        super.viewDidLoad()
        self.data.changed = false
        setupViews()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - Help Functions
    func setupViews() {
        
        self.view.removeSubViews()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Spieler"
        
        // NavigationBar
        let navBar = UINavigationBar()
        if data.rightToChangeData {
            navBar.defaultNavigationBar(title, viewController: self, lBTitle: "back", lBFunc: "backButtonAction:", rBTitle: "add", rBFunc: "newPersonButtonAction:")
            
        } else {
            navBar.defaultNavigationBar(title, viewController: self, lBTitle: "back", lBFunc: "backButtonAction:")
            
        }
        self.view.addSubview(navBar)
        
        // TableView
        tableView = UITableView(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.frame.width, self.view.frame.height - CGRectGetMaxY(navBar.frame)))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
    }
    
    // Neue Person hinzufügen
    func newPersonButtonAction(button: UIButton) {
        
        let alert = AlertViewController()
        alert.info(self, title: "Neuer Spieler", text: "Neuen Spieler hinzufügen", placeholder: "Name", buttonText: "Speichern",  cancelButtonText: "Abbrechen")
        alert.addAction {
            
            let name = alert.textField1.text
            
            if name == "" {
                alert.errorLabel.text = "* Ein Name muss angeben werden!"
            } else if let oPER = self.data.arrayPersons.filter( { $0.name == name } ).first {
                alert.errorLabel.text = "* Der Name \(name) ist bereits vorhanden!"
            }
            else if count(name) > 50 {
                alert.errorLabel.text = "* Es sind maximal 50 Zeichen erlaubt!"
            }
            else {
                if self.data.addPerson(name) {
                self.tableView.reloadData()
                alert.closeView(false)
                } else {
                    alert.textField1.endEditing(false)
                    var alertview = AlertViewController().show(self, title: "Keine Interverbindung", text: "Es besteht keine Verbindung zum Server. Bitte das Internet aktivieren oder es in ein paar Minuten erneut probieren!", minusPos: true, buttonText: "OK", color: UIColorFromHex(0xe74c3c, alpha: 1))
                }
            }
        }
    }
    
    // Zurück
    func backButtonAction(button: UIButton) {
        self.tableView.editing = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView
    // Zeilen
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.arrayPersons.count
    }
    
    // Zeilenhöhe
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    // Table Cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        let oPER = data.arrayPersons[indexPath.row]
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell!.selectionStyle = .None
        }
        
        cell!.textLabel?.font = oPER.me ? .boldSystemFontOfSize(16.0) : .systemFontOfSize(16.0)
        cell!.textLabel?.textColor = oPER.visible ? UIColor.blackColor() : UIColor.lightGrayColor()

        cell!.textLabel?.text = oPER.name
        
        return cell!
    }

    // Cell Klick - Spieler bearbeiten
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if data.rightToChangeData {
            let oPER = data.arrayPersons[indexPath.row]
        
            let alert = AlertViewController()
            alert.info(self, title: "Spieler bearbeiten", text: "Spieler \(oPER.name) bearbeiten", placeholder: "Name", buttonText: "Speichern",  cancelButtonText: "Abbrechen")
            alert.addAction {
            
                let name = alert.textField1.text
            
                if name == "" {
                    alert.errorLabel.text = "* Ein Name muss angeben werden!"
                } else if let oPER = self.data.arrayPersons.filter( { $0.name == name } ).first {
                    alert.errorLabel.text = "* Der Name \(name) ist bereits vorhanden!"
                }
                else if count(name) > 50 {
                    alert.errorLabel.text = "* Es sind maximal 50 Zeichen erlaubt!"
                }
                else {
                    if self.data.updatePerson(indexPath.row, name: name) {
                        self.tableView.reloadData()
                        alert.closeView(false)
                    } else {
                        alert.textField1.endEditing(false)
                        var alertview = AlertViewController().show(self, title: "Keine Interverbindung", text: "Es besteht keine Verbindung zum Server. Bitte das Internet aktivieren oder es in ein paar Minuten erneut probieren!", minusPos: true, buttonText: "OK", color: UIColorFromHex(0xe74c3c, alpha: 1))
                    }
                }
            }
        }
    }
    
    // Cell bearbeitbar
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // Action für Cell
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        let oPER = data.arrayPersons[indexPath.row]
        let alert = AlertViewController()
        var deleteAction: UITableViewRowAction?

        // Spieler löschen
        if data.rightToChangeData {
            deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Löschen" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            alert.info(self, title: "Spieler löschen", text: "Möchten Sie den Spieler \(oPER.name) wirklich löschen? Das Löschen kann nicht rückgängig gemacht werden!", buttonText: "Löschen",  cancelButtonText: "Abbrechen")
            alert.addAction {
                    if self.data.deletePerson(indexPath.row) {
                        self.tableView.reloadData()
                        alert.closeView(false)
                    } else {
                        var alertview = AlertViewController().show(self, title: "Keine Interverbindung", text: "Es besteht keine Verbindung zum Server. Bitte das Internet aktivieren oder es in ein paar Minuten erneut probieren!", minusPos: false, buttonText: "OK", color: UIColorFromHex(0xe74c3c, alpha: 1))
                    }
                }
                self.tableView.editing = false
                return
            })
        }
        
        // Spieler ausblenden
        var hiddeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: oPER.visible ? "Ausblenden" : "Einblenden" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            self.tableView.editing = false
            self.data.hidePerson(indexPath.row, setVisible: !oPER.visible)
            self.tableView.reloadData()

            return
        })
        
        // Spieler als "Ich" markieren        
        var meAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: oPER.me ? "Nicht ich" : "Ich" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            self.tableView.editing = false
            self.data.setPersonToMe(indexPath.row, setMe: !oPER.me)
            self.tableView.reloadData()

            return
        })
        
        meAction.backgroundColor = UIColor.greenColor()
        hiddeAction.backgroundColor = UIColor.orangeColor()
        if deleteAction == nil {
            return [hiddeAction, meAction]
        } else {
            return [deleteAction!,hiddeAction, meAction]
        }
    }
}
