//
//  SearchPresenter.swift
//  Image Search
//
//  Created by Akin Ogunc on 27.10.2022.
//

//guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

import Foundation
import UIKit

protocol SearchPresenterDelegate: AnyObject{
    func presentPhotos(hits: [Hit])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = SearchPresenterDelegate & UIViewController

class SearchPresenter{
    
    weak var delegate: PresenterDelegate?
    
    public func getPhotos(query: String){
        
        let apiKey = "18021445-326cf5bcd3658777a9d22df6f"
        let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        guard let url = URL(string: "https://pixabay.com/api/?key=\(apiKey)&q=\(escapedString!)&image_type=photo") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let response = try JSONDecoder().decode(Response.self, from: data)
                self?.delegate?.presentPhotos(hits: response.hits)
            }
            catch{
                print(error)
            }
        })
        task.resume()

    }
    
    public func showAlert(title: String, message: String){
        delegate?.presentAlert(title: title, message: message)
    }
    
    public func setViewDelegate(delegate: PresenterDelegate){
        self.delegate = delegate
    }
    
    public func showSelectedImages(selected: [URL]){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        detailView.selectedImages = selected
        self.delegate?.navigationController?.pushViewController(detailView, animated: true)
    }
}
