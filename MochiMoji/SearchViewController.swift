//
//  SearchViewController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 1/26/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.alpha = 0
        cancelButton.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("searchViewToMain", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        backButton.alpha = 1
        springScaleFrom(backButton!, -100, 0, 0.5, 0.5, 0.3)
        
        cancelButton.alpha = 1
        springScaleFrom(cancelButton!, 100, 0, 0.5, 0.5, 0.3)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
