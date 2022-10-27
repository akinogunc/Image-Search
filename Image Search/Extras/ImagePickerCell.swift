//
//  ImagePickerCell.swift
//  Image Search
//
//  Created by Akin Ogunc on 27.10.2022.
//

import Foundation
import UIKit

class ImagePickerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tick: UIImageView!

    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
}
