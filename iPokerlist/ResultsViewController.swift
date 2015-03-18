//
//  ResultsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITextFieldDelegate, iUIDatePickerDelegate {
    
    var textBoxTag = 0
    var data: Data!
    var scrollView = UIScrollView()
    var bottomView = UIView()
    let navBar = UINavigationBar()
    var iDatePicker = iUIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    
    // MARK: - Help Functions
    // Views aufbauen
    func setupViews() {
        
        self.view.removeSubViews()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Neues Ergebnis"
        
        // NavigationBar
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "Zurück", lBFunc: "backButtonAction:", rBTitle: "Spieler", rBFunc: "personsButtonAction:")
        self.view.addSubview(navBar)
        
        // iDatePicker
        iDatePicker = iUIDatePicker(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.frame.width, 0))
        iDatePicker.backgroundColor = UIColor.brownColor()
        iDatePicker.iDatePickerDelegate = self
        self.view.addSubview(iDatePicker)
        
        // ScrollView
        scrollView = UIScrollView(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame) + iDatePicker.dateButtonHeight, self.view.frame.width, self.view.frame.height - CGRectGetMaxY(navBar.frame) - iDatePicker.dateButtonHeight - 44))
        scrollView.backgroundColor = UIColor.whiteColor()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(data.arrayPersons.count) * 40.00)
        
        let keyboardToolbar = getKeyBoard()
        
        var tagCounter = 1
        var lastY: CGFloat = 5.00
        
        for oPER in data.arrayPersons {
            
            let sizeLabel = CGRectMake(10, lastY, scrollView.frame.width - 40 - 164, 30)
            let sizeTextBoxIn = CGRectMake(CGRectGetMaxX(sizeLabel) + 10, lastY, 82, 30)
            let sizeTextBoxOut = CGRectMake(CGRectGetMaxX(sizeTextBoxIn) + 10, lastY, 82, 30)
            
            let label = UILabel(frame: sizeLabel)
            let textBoxIn = UITextField(frame: sizeTextBoxIn)
            let textBoxOut = UITextField(frame: sizeTextBoxOut)
            
            label.tag = (vInt("\(data.PKL_ID)\(oPER.id)") * 100)
            textBoxIn.tag = (vInt("\(data.PKL_ID)\(oPER.id)") * 100) + 1
            textBoxOut.tag = (vInt("\(data.PKL_ID)\(oPER.id)") * 100) + 2
            

            textBoxIn.delegate = self
            textBoxOut.delegate = self

            textBoxIn.borderStyle = UITextBorderStyle.Line
            textBoxOut.borderStyle = UITextBorderStyle.Line
            
            textBoxIn.keyboardType = UIKeyboardType.DecimalPad
            textBoxOut.keyboardType = UIKeyboardType.DecimalPad
            
            textBoxIn.inputAccessoryView = keyboardToolbar
            textBoxOut.inputAccessoryView = keyboardToolbar
            
            label.text = oPER.name
            
            scrollView.addSubview(label)
            scrollView.addSubview(textBoxIn)
            scrollView.addSubview(textBoxOut)

            tagCounter += 2
            lastY = 10.00 + CGRectGetMaxY(sizeLabel)
        }

        self.view.addSubview(scrollView)
        
        // bottomView
        bottomView = UIView(frame: CGRectMake(0, CGRectGetMaxY(scrollView.frame), self.view.frame.width, 44))
        let saveButton = UIButton(frame: CGRectMake(0, 0, bottomView.frame.width, bottomView.frame.height))
        saveButton.setTitle("Speichern", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "saveButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(saveButton)
        bottomView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(bottomView)
        
    }
    
    // Eigene KeyBoard Button erstellen
    func getKeyBoard() -> UIToolbar {
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.backgroundColor = UIColor.whiteColor()
        
        let nextBarButton = UIBarButtonItem(title: "Weiter", style: .Plain, target: self, action: Selector("goToTextField:"))
        nextBarButton.width = self.view.frame.width / 3
        nextBarButton.tag = 1
        
        let previousBarButton = UIBarButtonItem(title: "Zurück", style: .Plain, target: self, action: Selector("goToTextField:"))
        previousBarButton.width = self.view.frame.width / 3
        previousBarButton.tag = -1
        
        let doneBarButton = UIBarButtonItem(title: "Fertig", style: .Plain, target: self, action: Selector("doneClicked:"))
        doneBarButton.width = self.view.frame.width / 3
        
        keyboardToolbar.items = [previousBarButton, doneBarButton, nextBarButton]
        return keyboardToolbar
    }
    
    // Daten validieren und/oder Speichern
    func validateAndSaveResults(succesfullValidated: Bool) -> Bool {
        
        var noErrors = true
        var zeroEntries = true
        for view in scrollView.subviews {
            if _stdlib_getTypeName(view) == "UILabel" {
                
                let tag = vInt((vString(view.tag) as NSString).substringWithRange(NSRange(location: countElements(vString(data.PKL_ID)), length: countElements(vString(view.tag)) - countElements(vString(data.PKL_ID)))))
                let PER_ID = tag / 100
                let textBoxIn = scrollView.viewWithTag(view.tag + 1) as UITextField
                let textBoxOut = scrollView.viewWithTag(view.tag + 2) as UITextField
                
                if succesfullValidated && textBoxIn.text != "" || textBoxOut.text != "" {
                    zeroEntries = false
                }
                
                if !succesfullValidated && ((textBoxIn.text == "" && textBoxOut.text != "") || (textBoxIn.text != "" && textBoxOut.text == "")) {
                    textBoxIn.backgroundColor = textBoxIn.text == "" ? UIColor.redColor() : UIColor.whiteColor()
                    textBoxOut.backgroundColor = textBoxOut.text == "" ? UIColor.redColor() : UIColor.whiteColor()
                    noErrors = false
                } else if succesfullValidated && textBoxIn.text != "" && textBoxOut.text != ""  {
                    
                    let oRES = Results(date: iDatePicker.date)
                    oRES.PKL_ID = data.PKL_ID
                    oRES.PER_ID = PER_ID
                    oRES.name = (view as UILabel).text!
                    oRES.chipsIn = vDouble(textBoxIn.text)
                    oRES.chipsOut = vDouble(textBoxOut.text)
                    oRES.addResultWS()
                    
                    data.arrayResults.append(oRES)
                }
            }
        }
        
        if !zeroEntries && noErrors && !succesfullValidated {
            validateAndSaveResults(true)
        }
        
        if succesfullValidated {
            data.sortArrayResults()
            data.groupBydate(TempDaten: data.arrayResults)
            data.calculateScore()
            data.calculateGroupedScores()
            data.changed = true
        }
        
        return noErrors && !zeroEntries

    }
    
    // Scrollview anpassen wenn sich die iDatepicker Größe ändert
    func resizeView(height: CGFloat) {
        scrollView.frame.origin.y = CGRectGetMaxY(navBar.frame) + height
        scrollView.frame.size.height = self.view.frame.height - CGRectGetMaxY(navBar.frame) - height - 44
    }
    
    // Textfield ist aktiv
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.backgroundColor = UIColor.whiteColor()
        textBoxTag = textField.tag
    }
    
    
    // Speichern / Validieren
    func saveButtonAction(button: UIButton) {
        if validateAndSaveResults(false) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Nächstes/Vorheriges TextField
    func goToTextField(button: UIButton) {
        
        for view in scrollView.subviews {
        }
       
        var actResponder: UIResponder? = scrollView.viewWithTag(textBoxTag)
        var nextResponder: UIResponder? = scrollView.viewWithTag(textBoxTag + 1)
        
        if (nextResponder != nil) {
            nextResponder!.becomeFirstResponder()
        } else if (actResponder != nil) {
            //actResponder!.resignFirstResponder()
            self.view.endEditing(true)
        }
        
    }
    
    // Tastatur ausblenden
    func doneClicked(button: UIButton) {
        self.view.endEditing(true)
    }
    
    // MARK: - BarButton Events
    // Zurück
    func backButtonAction(button: UIButton) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Personen öffnen
    func personsButtonAction(button: UIButton) {
        let personsView = PersonsViewController()
        personsView.data = data
        self.presentViewController(personsView, animated: true, completion: nil)
    }
    
}


