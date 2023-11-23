//
//  ViewController.swift
//  CarPoolIn
//
//  Created by Student on 20/11/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(transitionToLoadingPage), userInfo: nil, repeats: false)
    }

    @objc func transitionToLoadingPage() {
        performSegue(withIdentifier: "DashboardDebug", sender: self)
    }
}

