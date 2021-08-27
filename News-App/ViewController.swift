//
//  ViewController.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var news: UITableView!
    var response: [Article] = []

    var refresh: UIRefreshControl {
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        ref.tintColor = UIColor.gray
        return ref
    }
    
    
    @objc func handleRefresh(_ control: UIRefreshControl)  {
        NetworkService.shared.getNews { result in
            guard let news = result else {
                print("Can't get News")
                return
            }
            self.response = news.articles
            DispatchQueue.main.async {
                self.news.reloadData()
            }
        }
        
        control.endRefreshing()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        news.delegate = self
        news.dataSource = self
        news.addSubview(refresh)
  
        NetworkService.shared.getNews { result in
            guard let news = result else {
                print("Can't get News")
                return
            }
            self.response = news.articles
            DispatchQueue.main.async {
                self.news.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath) as! NewsTableViewCell
        let article = self.response[indexPath.row]
        cell.newsHeader.text = article.title
        cell.newsSource.text = article.source.name
        cell.newsDescription.text = article.content ?? article.description
        cell.mainImage.layer.cornerRadius = 15
        cell.mainImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.mainImage.sd_setImage(with: URL(string: article.urlToImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjCAfVgATBaPFFWX2WWJF6x-gVW4P1mdvfKA&usqp=CAU"), completed: nil)
        
        return cell
    }

    fileprivate func addGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        layer.startPoint = CGPoint(x: 1.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(layer, at: 0)
    }
    
}

