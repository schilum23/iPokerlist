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
    var viewHeader = UIView()
    var bottomView = UIView()
    let navBar = UINavigationBar()
    var iDatePicker = iUIDatePicker()
    var keyboardSize: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        setupViews()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height = self.view.frame.height - CGRectGetMaxY(viewHeader.frame) - keyboardSize.height
            self.keyboardSize = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height = self.view.frame.height - CGRectGetMaxY(viewHeader.frame) - 44
            self.keyboardSize = 44
        }
    }
    
    // MARK: - Help Functions
    // Views aufbauen
    func setupViews() {
        
        self.view.removeSubViews()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var title = "Neues Ergebnis"
        
        // NavigationBar
        navBar.defaultNavigationBar(title, viewController: self, lBTitle: "back", lBFunc: "backButtonAction:", rBTitle: "person", rBFunc: "personsButtonAction:")
        self.view.addSubview(navBar)
        
        // iDatePicker
        iDatePicker = iUIDatePicker(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame), self.view.frame.width, 0))
        iDatePicker.backgroundColor = UIColor.whiteColor()
        iDatePicker.iDatePickerDelegate = self
        self.view.addSubview(iDatePicker)
        
        // Überschriften
        let sizeLabelH = CGRectMake(10, 0, self.view.frame.width - 40 - 164, 44)
        let sizetextFieldInH = CGRectMake(CGRectGetMaxX(sizeLabelH) + 10, 0, 82, 44)
        let sizetextFieldOutH = CGRectMake(CGRectGetMaxX(sizetextFieldInH) + 10, 0, 82, 44)
        viewHeader = UIView(frame: CGRectMake(0, CGRectGetMaxY(navBar.frame)  + iDatePicker.dateButtonHeight, self.view.frame.width, 44))
        viewHeader.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(viewHeader)
        
        let viewBorder = UIView(frame: CGRectMake(0, 42, self.view.frame.width, 2))
        viewBorder.backgroundColor = UIColor.blackColor()
        viewHeader.addSubview(viewBorder)

        
        let labelName = UILabel(frame: sizeLabelH)
        labelName.textAlignment = NSTextAlignment.Left
        labelName.font = .boldSystemFontOfSize(16.0)
        labelName.text = "Name"
        
        let labelEin = UILabel(frame: sizetextFieldInH)
        labelEin.textAlignment = .Center
        labelEin.font = .boldSystemFontOfSize(16.0)
        labelEin.text = "Ein"
        
        let labelAus = UILabel(frame: sizetextFieldOutH)
        labelAus.textAlignment = .Center
        labelAus.font = .boldSystemFontOfSize(16.0)
        labelAus.text = "Aus"
        
        viewHeader.addSubview(labelName)
        viewHeader.addSubview(labelEin)
        viewHeader.addSubview(labelAus)
        
        // ScrollView
        scrollView = UIScrollView(frame: CGRectMake(0, CGRectGetMaxY(viewHeader.frame), self.view.frame.width, self.view.frame.height - CGRectGetMaxY(viewHeader.frame) - 44))
        scrollView.backgroundColor = UIColor.whiteColor()
        
        let keyboardToolbar = getKeyBoard()
        
        var tagCounter = 1
        var lastY: CGFloat = 5.00
        
        for oPER in data.arrayPersons {
            
            if oPER.visible {
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
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(data.arrayPersons.filter( { $0.visible } ).count) * 40.00)
        self.view.addSubview(scrollView)
        
        // bottomView
        bottomView = UIView(frame: CGRectMake(0, CGRectGetMaxY(scrollView.frame), self.view.frame.width, 44))
        let saveButton = UIButton(frame: CGRectMake(0, 0, bottomView.frame.width, bottomView.frame.height))
        saveButton.setTitle("Speichern", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "saveButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(saveButton)
        bottomView.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        self.view.addSubview(bottomView)
        
    }
    
    // Eigene KeyBoard Button erstellen
    func getKeyBoard() -> UIToolbar {
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.backgroundColor = UIColor.whiteColor()
        
        let nextBarButton = UIBarButtonItem(title: "Weiter", style: .Plain, target: self, action: Selector("goToTextField:"))
        nextBarButton.tag = 1
        
        let previousBarButton = UIBarButtonItem(title: "Zurück", style: .Plain, target: self, action: Selector("goToTextField:"))
        previousBarButton.tag = -1
        
        let doneBarButton = UIBarButtonItem(title: "Fertig", style: .Plain, target: self, action: Selector("doneClicked:"))
        
        let flex1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
  
        let flex2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        keyboardToolbar.items = [previousBarButton, flex1, doneBarButton, flex2, nextBarButton]
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
                    
                    data.addResult(iDatePicker.date, PER_ID: PER_ID, chipsIn: textFieldIn.text, chipsOut: textFieldOut.text)
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
            data.saveDataToCoreData()
            data.changed = true
        }
        
        if !noErrors {

            var customIcon = UIImage(named: "lightbulb")
            var alertview = AlertViewController().show(self, title: "Speichern nicht möglich! ", text: "Es wurde nicht nicht für alle Spieler die korrekten Ein- und Auszahlungen angegeben.", buttonText: "OK", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
            alertview.setTextTheme(.Light)
        }
        
        if zeroEntries && noErrors {
            var customIcon = UIImage(named: "lightbulb")
            var alertview = AlertViewController().show(self, title: "Speichern nicht möglich! ", text: "Keine Daten angegeben.", buttonText: "OK", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
            alertview.setTextTheme(.Light)

        }
        
        return noErrors && !zeroEntries

    }
    
    // HeaderView anpassen wenn sich die iDatepicker Größe ändert
    func resizeView(height: CGFloat) {
        viewHeader.frame.origin.y = CGRectGetMaxY(navBar.frame) + height
        
        scrollView.frame.origin.y = CGRectGetMaxY(viewHeader.frame)
        scrollView.frame.size.height = self.view.frame.height - CGRectGetMaxY(viewHeader.frame) - self.keyboardSize

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
        } else  {
            self.view.endEditing(true)
            if scrollView.contentSize.height < (scrollView.contentOffset.y + scrollView.frame.size.height) {
                scrollView.setContentOffset(CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height), animated: true)
            }
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


