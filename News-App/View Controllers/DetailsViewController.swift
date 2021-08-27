//
//  DetailsViewController.swift
//  News-App
//
//  Created by Иван Карамазов on 27.08.2021.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController, UITextViewDelegate {

    let placeholderURL = "https://www.industry.gov.au/sites/default/files/August%202018/image/news-placeholder-738.png"
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var image: UIImageView!

    var news: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let news = news {
            let imageURL = URL(string: news.urlToImage ?? placeholderURL)
            image.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "Placeholder"), completed: nil)
            header.text = news.title
            source.text = news.source.name
            descr.text = news.content ?? news.description
        }
    
    }
    

}
