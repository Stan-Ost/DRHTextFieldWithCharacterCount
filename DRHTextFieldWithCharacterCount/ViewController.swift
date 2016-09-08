//
//  ViewController.swift
//  DRHTextFieldWithCharacterCount
//
//  Created by Stanislav Ostrovskiy on 8/29/16.
//  Copyright © 2016 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: DRHTextFieldWithCharacterCount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField?.drhDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: DRHTextFieldWithCharacterCountDelegate {
    func didEndEditing() {
        print("end editing")
    }
    func didBeginEditing() {
        print("begin editing")
    }
    func didReachCharacterLimit(_ reach: Bool) {
        if reach {
            print("limit reached")
        } else {
            print("have more chars to go")
        }
    }
}
