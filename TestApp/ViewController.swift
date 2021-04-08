//
//  ViewController.swift
//  TestApp
//
//  Created by Stephen O'Connor (MHP) on 20.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var catalogLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var clrLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.catalogLabel.backgroundColor = GeneratedColors.myGrey
        self.codeLabel.backgroundColor = GeneratedColors.myBlack
        let colorCode = "#3d78fe" // corresponds to myBlue
        let values = UIColor.rgba(from: colorCode)
        guard let v = values, let color = UIColor(values: values)  else { return }
        
        self.colorLabel.backgroundColor = color
        
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if r != v.red {
            print("Red Failed")
        }
        
        if g != v.green {
            print("Green Failed")
        }
        
        if b != v.blue {
            print("Blue Failed")
        }
        
        if a != v.alpha {
            print("Alpha Failed")
        }
   
        if color.compare(other: GeneratedColors.myBlue) == false {
            print("Asset Catalog Color failed")
        }
        if color.compare(other: .app_myBlue) == false {
            print("Swift Generated Color failed")
        }
        
    }
}

extension UIColor {
    
    func compare(other: UIColor) -> Bool {
        
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var or = CGFloat(0)
        var og = CGFloat(0)
        var ob = CGFloat(0)
        var oa = CGFloat(0)
        
        other.getRed(&or, green: &og, blue: &ob, alpha: &oa)
        
        // we could have had rounding errors, so we make sure that these floats, when mapped back
        // to Int values, ultimately generate what you expect.
        let intR = Int(r*255)
        let intG = Int(g*255)
        let intB = Int(b*255)
        let intA = Int(a*255)
        
        let intOR = Int(or*255)
        let intOG = Int(og*255)
        let intOB = Int(ob*255)
        let intOA = Int(oa*255)

        if intR != intOR {
            return false
        }
        
        if intG != intOG {
            return false
        }
        
        if intB != intOB {
            return false
        }
        
        if intA != intOA {
            return false
        }
        
        return true
    }
    
}

