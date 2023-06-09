//
//  roundedImageView.swift
//  ContactsApp
//
//  Created by Mustafa Öztürk on 28.05.2023.
//

import UIKit
@IBDesignable

class roundedImageView: UIImageView {

    @IBInspectable var roundedImage:Bool = false {
        didSet {
            if roundedImage {
                layer.cornerRadius = layer.frame.size.height / 2
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundedImage {
            layer.cornerRadius = layer.frame.size.height / 2
        }
    }

}
