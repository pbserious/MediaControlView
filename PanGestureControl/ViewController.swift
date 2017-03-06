//
//  ViewController.swift
//  PanGestureControl
//
//  Created by Rattee Wariyawutthiwat on 3/5/2560 BE.
//  Copyright © 2560 Rattee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var controlView: MockMediaControlView!

    @IBAction func enableGesture(_ sender: Any) {
        controlView.isGestureActive = !controlView.isGestureActive
    }
}

