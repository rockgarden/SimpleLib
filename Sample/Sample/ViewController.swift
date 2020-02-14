//
//  ViewController.swift
//  Sample
//
//  Created by 王侃 on 2020/2/13.
//  Copyright © 2020 王侃. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// CLTypingLabel
        demoLabel.charInterval = 0.1
    }
    
    // MARK: - showSelectionDialog
    @IBAction func showSelectionDialog() {
        let dialog = SelectionDialog(title: "Dialog", closeButtonTitle: "Close")
        
        dialog.addItem(item: "I have icon :)",
                       icon: UIImage(named: "Icon1")!)
        
        dialog.addItem(item: "I have icon and handler :D",
                       icon: UIImage(named: "Icon2")!,
                       didTapHandler: { () in
                        print("Item didTap!")
        })
        
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.addItem(item: "I have nothing :(")
        dialog.show()
    }
    
    // MARK: - CLTypingLabel
    @IBOutlet weak var demoLabel: CLTypingLabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set Text
        demoLabel.text = "This is a demo of a typing label animation..."
        demoLabel.onTypingAnimationFinished = { [unowned self] in
            self.showSampleAlert()
        }
    }
    
    fileprivate func showSampleAlert() {
        let sampleAlert = UIAlertController(title: "Sample",
                                            message: "Typing animation finished!",
                                            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        sampleAlert.addAction(okAction)
        self.present(sampleAlert, animated: true, completion: nil)
    }
    
    @IBAction func stopTapped(_ sender: AnyObject) {
        demoLabel.pauseTyping()
    }
    @IBAction func continueTapped(_ sender: AnyObject) {
        demoLabel.continueTyping()
    }
    
    var showNoramlText = false
    
    @IBAction func restartTapped(_ sender: AnyObject) {
        demoLabel.text = "This is a demo of a typing label animation..."
    }
    
    // MARK: - ICanhas
    @IBOutlet weak var pushLabel: UILabel!
    @IBAction func tappedPush(_ sender: AnyObject) {
        ICanHas.push { authorized in
            self.pushLabel.text = authorized.text
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBAction func tappedLocation(_ sender: AnyObject) {
        ICanHas.location { authorized, status in
            self.locationLabel.text = authorized.text
        }
    }
    
    @IBOutlet weak var cameraLabel: UILabel!
    @IBAction func tappedCamera(_ sender: AnyObject) {
        ICanHas.capture { authorized, status in
            self.cameraLabel.text = authorized.text
        }
    }
    
    @IBOutlet weak var photosLabel: UILabel!
    @IBAction func tappedPhotos(_ sender: AnyObject) {
        ICanHas.photos { authorized, status in
            self.photosLabel.text = authorized.text
        }
    }
    
    @IBOutlet weak var contactsLabel: UILabel!
    @IBAction func tappedContacs(_ sender: AnyObject) {
        ICanHas.contacts { authorized, status, error in
            self.contactsLabel.text = authorized.text
        }
    }
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBAction func tappedCalendar(_ sender: AnyObject) {
        ICanHas.calendar { authorized, status, error in
            self.calendarLabel.text = authorized.text
            
        }
    }
    
}

