//
//  DetailViewController.swift
//  Image Search
//
//  Created by Akin Ogunc on 27.10.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    var selectedImages: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selected Images"
            
        for i in 0..<selectedImages.count{
            ImageCache.getImage(url: selectedImages[i].absoluteString, completion: { (image) in
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: self.view.frame.width*CGFloat(i) + CGFloat(10*i), width: self.view.frame.width, height: self.view.frame.width)
                imageView.contentMode = .scaleAspectFill
                imageView.layer.masksToBounds = true
                
                DispatchQueue.main.async {
                    self.scrollView.addSubview(imageView)
                }
            })
        }
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: (self.view.frame.width)*CGFloat(selectedImages.count) + CGFloat(10*selectedImages.count))
    }

}
