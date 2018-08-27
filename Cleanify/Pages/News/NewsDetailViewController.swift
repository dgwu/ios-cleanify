//
//  NewsDetailViewController.swift
//  Cleanify
//
//  Created by Kevin Wijaya on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDesc: UILabel!
    
    var selectedNews: CleanifyNew?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
   
    func setupView(){
        if let news = selectedNews {
            newsTitle.text = news.title
            newsDesc.text = news.description
            newsImage.image = UIImage(named:"headnews3")
            
            GeneralHelper.fetchImage(from: news.photoUrl) { (fetchedImage) in
                if let fetchedImage = fetchedImage {
                    DispatchQueue.main.async {
                        self.newsImage.image = fetchedImage
                    }
                }
            }
        }
    }



}
