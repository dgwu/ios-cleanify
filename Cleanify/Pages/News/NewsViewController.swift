//
//  NewsViewController.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
   
    
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images: [String] = ["headnews0","headnews1","headnews2","headnews3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
   
    var dummyNews: [CleanifyNew] = [CleanifyNew]()
    var newsList: [CleanifyNew] = [CleanifyNew]()
    var selectedNews: CleanifyNew?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController.numberOfPages = images.count
        
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
            
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTable()
        loadNews()
    }
    
    
    
    func loadNews() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let loadingAlert = GeneralHelper.getLoadingAlert()
        self.navigationController?.present(loadingAlert, animated: true, completion: nil)
        
        let cleanifyApi = CleanifyApi()
        cleanifyApi.fetchNewsList { (newsList) in
            if let newsList = newsList {
                self.newsList = newsList
                
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    loadingAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func setupTable() {
//        createDummyNews()
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
    }
    
    
    func createDummyNews() {
        for i in 1...5 {
            let dummyNew = CleanifyNew(id: i, title: "News \(i)", body: "hulala", description: "desc \(i)", photoUrl: "bz", createdAt: "2018-08-24")
            self.dummyNews.append(dummyNew)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageController.currentPage = Int(pageNumber)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        let news = newsList[indexPath.row]
        
        cell.NewsTitle.text = news.title
        cell.NewsDesc.text = news.description
        cell.NewsImage.image = UIImage(named: "headnews3")
        GeneralHelper.fetchImage(from: news.photoUrl) { (fetchedImage) in
            if let fetchedImage = fetchedImage {
                DispatchQueue.main.async {
                    cell.NewsImage.image = fetchedImage
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = newsList[indexPath.row]
        performSegue(withIdentifier: "toNewsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewsDetail"){
            if let destination = segue.destination as? NewsDetailViewController{
                destination.selectedNews = self.selectedNews
            }
        }
    }
}

