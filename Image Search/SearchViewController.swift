//
//  ViewController.swift
//  Image Search
//
//  Created by Akin Ogunc on 27.10.2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, SearchPresenterDelegate{

    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    private let searchPresenter = SearchPresenter()
    var cellSize: CGFloat!
    var imageData: [Hit] = []
    var selectedImages: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Search"
        cellSize = (view.bounds.width - 3) / 4 //3 images for a row

        //show selected images button
        let showSelectedButton:UIBarButtonItem = UIBarButtonItem(title: "Show", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSelectedImages))
        self.navigationItem.rightBarButtonItem = showSelectedButton;

        searchPresenter.setViewDelegate(delegate: self)
        searchBar.becomeFirstResponder()
    }

    //navigation bar button selector
    @objc func showSelectedImages(){
        if(selectedImages.count < 2){
            searchPresenter.showAlert(title: "Error", message: "Select at least 2 images")
        }else{
            searchPresenter.showSelectedImages(selected: selectedImages)
        }
    }

    //search bar handling
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text! == ""){
            searchPresenter.showAlert(title: "Error", message: "Please enter a query")
        }else{
            selectedImages.removeAll()
            searchPresenter.getPhotos(query: searchBar.text!)
            searchBar.resignFirstResponder()
        }
    }

    //show photos after presenter gets them
    func presentPhotos(hits: [Hit]) {
        imageData.removeAll()
        imageData = hits
        
        if(hits.count == 0){
            searchPresenter.showAlert(title: "No Result", message: "Try another query")
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func presentAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
}

//collectionview protocols
extension SearchViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as! ImagePickerCell
        cell.tick.isHidden = true
                
        ImageCache.getImage(url: imageData[indexPath.row].previewURL.absoluteString, completion: { (image) in
            DispatchQueue.main.async {
                cell.image = image
            }
        })
        
        return cell
    }
    
}

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? ImagePickerCell {
            if(currentCell.tick.isHidden){
                currentCell.tick.isHidden = false
                selectedImages.append(imageData[indexPath.row].largeImageURL)
            }else{
                currentCell.tick.isHidden = true
                
                if let index = selectedImages.firstIndex(of: imageData[indexPath.row].largeImageURL) {
                    selectedImages.remove(at: index)
                }
            }
        }
    }

}


extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}
