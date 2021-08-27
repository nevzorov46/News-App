//
//  ViewController.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let placeholderURL = "https://www.industry.gov.au/sites/default/files/August%202018/image/news-placeholder-738.png"
    @IBOutlet weak var news: UITableView!
    var response: [Article] = []
    var selectedNews: Article?
    var refresh: UIRefreshControl {
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        ref.tintColor = UIColor.gray
        return ref
    }
    
    @objc func handleRefresh(_ control: UIRefreshControl)  {
        getNews()
        control.endRefreshing()
    }
    
    private func getNews() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        news.delegate = self
        news.dataSource = self
        news.addSubview(refresh)
        
        getNews()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath) as! NewsTableViewCell
        let article = self.response[indexPath.row]
        let imageURL = URL(string: article.urlToImage ?? placeholderURL)
        cell.newsHeader.text = article.title
        cell.newsSource.text = article.source.name
        cell.newsDescription.text = article.content ?? article.description
        cell.mainImage.layer.cornerRadius = 15
        cell.mainImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.mainImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "Placeholder"), completed: nil)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = response[indexPath.row]
        selectedNews = news
        performSegue(withIdentifier: "openDetails", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetails", let vc = segue.destination as? DetailsViewController, let news = selectedNews {
            vc.news = news
        }
    }

    private func addGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        layer.startPoint = CGPoint(x: 1.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(layer, at: 0)
    }
    
   
    private func setupNavigationItem() {
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.backButtonTitle = ""
    }
  
}

