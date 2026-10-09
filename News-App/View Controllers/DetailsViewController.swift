//
//  DetailsViewController.swift
//  News-App
//
//  Created by Иван Карамазов on 27.08.2021.
//

import UIKit
import SafariServices
import SDWebImage

class DetailsViewController: UIViewController {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var image: UIImageView!

    var news: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let news = news {
            image.sd_setImage(with: news.imageURL, placeholderImage: UIImage(named: "Placeholder"), completed: nil)
            header.text = news.title
            source.text = news.source?.name
            descr.text = news.text
            if let url = news.webURL {
                addOpenButton(url)
            }
        }

    }

    // The API gives only the beginning of an article, the rest is on the publisher's site.
    private func addOpenButton(_ url: URL) {
        let open = UIAction(title: "Read Full Article", image: UIImage(systemName: "safari")) { [weak self] _ in
            self?.present(SFSafariViewController(url: url), animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: open)
    }

}
