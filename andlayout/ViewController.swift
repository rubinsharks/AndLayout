//
//  ViewController.swift
//  andlayout
//
//  Created by RubinYeom on 2017. 5. 28..
//  Copyright (c) 2017 UXInter. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let parser = TKLayoutParser(frame: self.view.frame)
        var view = parser.getViewFromXML(fromXML: "main")
        var button = view!.findViewById(id: "button")
        if let clickButton = button as? UIButton {
            clickButton.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        }
        if let uiview = view as? UIView {
            self.view = uiview
        }
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }


    func buttonClicked(sender: UIButton) {
        var secondView = SecondViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(secondView, animated: true)
    }
}
