//
//  ResultsViewController.swift
//  iPokerlist
//
//  Created by Oliver Rosner on 08.03.15.
//  Copyright (c) 2015 Oliver Rosner. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITextFieldDelegate, iUIDatePickerDelegate {
    
    var textFieldTag = 0
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if data.changed {
            setupViews()
        }
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
            let sizetextFieldIn = CGRectMake(CGRectGetMaxX(sizeLabel) + 10, lastY, 82, 30)
            let sizetextFieldOut = CGRectMake(CGRectGetMaxX(sizetextFieldIn) + 10, lastY, 82, 30)
            
            let label = UILabel(frame: sizeLabel)
            let textFieldIn = iUITextField(frame: sizetextFieldIn)
            let textFieldOut = iUITextField(frame: sizetextFieldOut)
            
            label.tag = (vInt("\(data.PKL_ID)\(oPER.id)") * 100)
            textFieldIn.tag = (vInt("\(data.PKL_ID)\(oPER.id)") * 100) + 1
            textFieldOut.tag = (vInt("\(data.PKL_ID)\(oPER.id)") * 100) + 2
            

            textFieldIn.delegate = self
            textFieldOut.delegate = self

            textFieldIn.borderStyle = UITextBorderStyle.Line
            textFieldOut.borderStyle = UITextBorderStyle.Line
            
            textFieldIn.keyboardType = UIKeyboardType.DecimalPad
            textFieldOut.keyboardType = UIKeyboardType.DecimalPad
            
            textFieldIn.inputAccessoryView = keyboardToolbar
            textFieldOut.inputAccessoryView = keyboardToolbar
            
            textFieldIn.number = tagCounter
            textFieldOut.number = tagCounter + 1
            
            label.font = oPER.me ? .boldSystemFontOfSize(16.0) : .systemFontOfSize(16.0)
            label.text = oPER.name
            
            scrollView.addSubview(label)
            scrollView.addSubview(textFieldIn)
            scrollView.addSubview(textFieldOut)

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
            if _stdlib_getDemangledTypeName(view) == "UILabel" {
                
                let tag = vInt((vString(view.tag) as NSString).substringWithRange(NSRange(location: count(vString(data.PKL_ID)), length: count(vString(view.tag)) - count(vString(data.PKL_ID)))))
                let PER_ID = tag / 100
                let textFieldIn = scrollView.viewWithTag(view.tag + 1) as! UITextField
                let textFieldOut = scrollView.viewWithTag(view.tag + 2) as! UITextField
                
                if succesfullValidated && textFieldIn.text != "" || textFieldOut.text != "" {
                    zeroEntries = false
                }
                
                if !succesfullValidated && ((textFieldIn.text == "" && textFieldOut.text != "") || (textFieldIn.text != "" && textFieldOut.text == "")) {
                    textFieldIn.backgroundColor = textFieldIn.text == "" ? UIColor.redColor() : UIColor.whiteColor()
                    textFieldOut.backgroundColor = textFieldOut.text == "" ? UIColor.redColor() : UIColor.whiteColor()
                    noErrors = false
                } else if succesfullValidated && textFieldIn.text != "" && textFieldOut.text != ""  {
                    
                    let oRES = Results(date: iDatePicker.date)
                    oRES.PKL_ID = data.PKL_ID
                    oRES.PER_ID = PER_ID
                    oRES.chipsIn = vDouble(textFieldIn.text)
                    oRES.chipsOut = vDouble(textFieldOut.text)
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
        
        if !noErrors {

            var customIcon = UIImage(named: "lightbulb")
            var alertview = AlertViewController().show(self, title: "Speichern nicht möglich! ", text: "Es wurde nicht nicht für alle Spieler die korrekten Ein- und Auszahlungen angegeben.", buttonText: "OK", color: UIColorFromHex(0x9b59b6, alpha: 1), iconImage: customIcon)
            alertview.setTextTheme(.Light)
        }
        
        if zeroEntries && noErrors {
            var customIcon = UIImage(named: "lightbulb")
            var alertview = AlertViewController().show(self, title: "Speichern nicht möglich! ", text: "Keine Daten angegeben.", buttonText: "OK", color: UIColorFromHex(0x9b59b6, alpha: 1), iconImage: customIcon)
            alertview.setTextTheme(.Light)

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
        
        let textiField = textField as! iUITextField
        
        textField.backgroundColor = UIColor.whiteColor()
        
        if textiField.number % 2 == 0 {
            if let textFieldSecond = scrollView.iUITextFieldWithNumber(textiField.number - 1) as? iUITextField {
                textFieldSecond.backgroundColor = UIColor.whiteColor()
            }
        } else {
            if let textFieldSecond = scrollView.iUITextFieldWithNumber(textiField.number + 1) as? iUITextField {
                textFieldSecond.backgroundColor = UIColor.whiteColor()
            }
        }
        
        textFieldTag = textiField.number
        
        scrollView.setContentOffset(CGPointMake(0, textField.frame.origin.y - 10), animated: true)
        

    }
    
    // Speichern / Validieren
    func saveButtonAction(button: UIButton) {
        if validateAndSaveResults(false) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Nächstes/Vorheriges TextField
    func goToTextField(button: UIButton) {
        
        var actResponder: UIResponder? = scrollView.iUITextFieldWithNumber(textFieldTag)
        var nextResponder: UIResponder? = scrollView.iUITextFieldWithNumber(textFieldTag + (1 * button.tag))
        
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
        
        if scrollView.contentSize.height < (scrollView.contentOffset.y + scrollView.frame.size.height) {
            scrollView.setContentOffset(CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height), animated: true)
        }

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


