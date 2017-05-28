//
//  ViewController.swift
//  mobileshop
//
//  Created by RubinYeom on 2017. 3. 29..
//  Copyright (c) 2017 UXInter. All rights reserved.
//

import UIKit


class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let parser = TKLayoutParser(frame: self.view.frame)
        var view = parser.getViewFromXML(fromXML: "content")
        if let uiview = view as? UIView {
            self.view = uiview
        }

        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addTapped)), animated: true)
    // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    func addTapped(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
