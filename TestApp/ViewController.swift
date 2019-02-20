//
//  ViewController.swift
//  TestApp
//
//  Created by Stephen O'Connor (MHP) on 20.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var catalogLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.codeLabel.backgroundColor = MyTestColors.myBlue
        self.codeLabel.backgroundColor = .t_myBlue
    }
}

