//
//  WordViewController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 5/8/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class WordViewController: UIViewController {
    
    override func viewDidLoad() {
        let stackSize = self.navigationController?.viewControllers.count
        println("Stack Size : \(stackSize)")
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        println("backButtonPressed")
        self.navigationController?.popViewControllerAnimated(false)
    }
}