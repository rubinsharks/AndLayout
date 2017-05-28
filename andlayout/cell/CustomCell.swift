//
// Created by RubinYeom on 2017. 5. 10..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {

    var view: ViewGroup?
    var animal: Animal!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("layoutSubviews")
        let parser = TKLayoutParser(frame: self.frame)
        view = parser.getViewFromXML(fromXML: "cell_custom")
        if let uiview = view as? UIView {
            contentView.addSubview(uiview)
        }
    }

    func setAnimal(animal: Animal) {
        if let text = view!.findViewById(id: "title") as? TextView {
            text.setText(text: animal.name)
        }
        if let text = view!.findViewById(id: "price") as? TextView {
            text.setText(text: animal.price)
        }
        self.animal = animal
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let rootView = view as? RootLayout {
            var cellFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            rootView.setFrame(rootFrame: cellFrame)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}