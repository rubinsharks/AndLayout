//
//  ViewController.swift
//  mobileshop
//
//  Created by RubinYeom on 2017. 3. 29..
//  Copyright (c) 2017 UXInter. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let animals : [Animal] = [Animal(name: "Dog", price: "10000"), Animal(name: "Cat", price: "5000"), Animal(name: "Pig", price: "15000")]

    override func viewDidLoad() {
        super.viewDidLoad()
        let parser = TKLayoutParser(frame: self.view.frame)
        var view = parser.getViewFromXML(fromXML: "table")
        if let uiview = view as? UIView {
            self.view = uiview
        }
        if let tableView = view!.findViewById(id: "list") as? UITableView {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        }
    // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.setAnimal(animal: animals[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("User selected table row \(indexPath.row) and item \(animals[indexPath.row])")

        var contentView = ContentViewController(nibName: nil, bundle: nil)
        let navController = UINavigationController(rootViewController: contentView)
        self.navigationController?.present(navController, animated: true)
    }
}
