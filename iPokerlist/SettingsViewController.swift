//
//  SettingsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 25.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var data: Data!
    var deleteView = UIView()
    var labelLink = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        data.changed = false
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
        var title = "Einstellungen"
        
        // NavigationBar
        let navBar = UINavigationBar()
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "back", lBFunc: "backButtonAction:")
        self.view.addSubview(navBar)
        
        // Button New
        let newView = UIView(frame: CGRectMake(44, (self.view.frame.height / 3) - 44, self.view.frame.width - 88, 44))
        let newButton = UIButton(frame: CGRectMake(0, 0, newView.frame.width, newView.frame.height))
        newButton.setTitle("Neue Liste erstellen", forState: UIControlState.Normal)
        newButton.addTarget(self, action: "newButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        newView.addSubview(newButton)
        newView.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        self.view.addSubview(newView)
        
        // Button Add
        let addView = UIView(frame: CGRectMake(44, CGRectGetMaxY(newView.frame) + 22, self.view.frame.width - 88, 44))
        let addButton = UIButton(frame: CGRectMake(0, 0, addView.frame.width, addView.frame.height))
        addButton.setTitle("Pokerliste hinzufügen", forState: UIControlState.Normal)
        addButton.addTarget(self, action: "getButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        addView.addSubview(addButton)
        addView.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        self.view.addSubview(addView)
        
        // Button Delete
        if vInt(self.data.PKL_ID) != 0 {
            deleteView = UIView(frame: CGRectMake(44, CGRectGetMaxY(addView.frame) + 22, self.view.frame.width - 88, 44))
            let deleteButton = UIButton(frame: CGRectMake(0, 0, deleteView.frame.width, deleteView.frame.height))
            deleteButton.setTitle("Pokerliste entfernen", forState: UIControlState.Normal)
            deleteButton.addTarget(self, action: "deleteButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            deleteView.addSubview(deleteButton)
            deleteView.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
            self.view.addSubview(deleteView)
            
            labelLink = UILabel(frame: CGRectMake(44, CGRectGetMaxY(deleteView.frame) + 10, self.view.frame.width - 88, 44))
            labelLink.text = "Link: \(self.data.PKL_Link)"
            labelLink.textAlignment = .Center
            self.view.addSubview(labelLink)

            
        }
        
        
        // bottomView
        let bottomView = UIView(frame: CGRectMake(0, self.view.frame.height - 44, self.view.frame.width, 44))
        let saveButton = UIButton(frame: CGRectMake(0, 0, bottomView.frame.width, bottomView.frame.height))
        saveButton.setTitle("Update", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "updateButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(saveButton)
        bottomView.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        self.view.addSubview(bottomView)
        
    }
    
    func newButtonAction(button: UIButton) {
 
        let alert = AlertViewController()
        
        alert.info(self, title: "Neue Liste", text: "Neue Pokerliste erstellen.", placeholder: "Name", placeholder2: "Passwort", buttonText: "Erstellen",  cancelButtonText: "Abbrechen")
        
        alert.addAction {
            
            if alert.textField1?.text == "" || alert.textField2?.text == "" {
                alert.errorLabel.text = "* Bitte Name und Passwort angeben!"

            } else if count(vString(alert.textField1?.text)) > 50 || count(vString(alert.textField2?.text)) > 50 {
                alert.errorLabel.text = "* Max. 50 Zeichen für Passwort und Link erlaubt!"
            } else {
                if self.data.addPKL(vString(alert.textField1?.text), PKL_Password: vString(alert.textField2?.text)) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }

            }
        }

    }

    func getButtonAction(button: UIButton) {
        
        let alert = AlertViewController()
        
        alert.info(self, title: "Liste hinzufügen", text: "Passwort wird nur benötigt um Daten bearbeiten zu können!", placeholder: "Link", placeholder2: "Passwort", buttonText: "Hinzufügen",  cancelButtonText: "Abbrechen")
        alert.textField2?.secureTextEntry = true
        
        alert.addAction {

            if alert.textField1?.text != "" {
                if self.data.getPKL(vString(alert.textField1?.text), PKL_Password: vString(alert.textField2?.text)) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    alert.errorLabel.text = "* Ungültige Angaben!"
                }

            } else {
                alert.errorLabel.text = "* Kein Link angegeben!"
            }
        }
    }
    
    func deleteButtonAction(button: UIButton) {
        
        let alert = AlertViewController()
        
        alert.info(self, title: "Liste entfernen", text: "Möchten Sie die Liste \(self.data.PKL_Name) wirklich entfernen? Alle Daten werden von diesem Gerät entfernt!", minusPos: false, buttonText: "Entfernen",  cancelButtonText: "Abbrechen")
        alert.addAction {
            self.data.removePKL()
            self.labelLink.removeFromSuperview()
            self.deleteView.removeFromSuperview()
            alert.closeView(false)
        }
    }
    
    func updateButtonAction(button: UIButton) {
        self.data.getUpdates()
        self.data.changed = true
    }
    
    func stateChanged(switcher: UISwitch) {
        self.data.changed = true
    }

    // MARK: - BarButton Events
    // Zurück
    func backButtonAction(button: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
