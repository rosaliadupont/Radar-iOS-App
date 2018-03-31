//
//  AlertViewController.swift
//  RADAR
//
//  Created by Rosalia Dupont on 9/1/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        /*let blurFx = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurFxView = UIVisualEffectView(effect: blurFx)
        blurFxView.frame = view.bounds
        //blurFxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurFxView, at: 0)*/

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }


}
