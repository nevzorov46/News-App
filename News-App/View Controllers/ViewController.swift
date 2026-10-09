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
    var selectedNews: Article?
    private let gradient = CAGradientLayer()
    private var isLoading = false
    private lazy var refresh: UIRefreshControl = {
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        ref.tintColor = UIColor.gray
        return ref
    }()

    @objc func handleRefresh(_ control: UIRefreshControl)  {
        getNews()
    }

    private func getNews() {
        guard !isLoading else { return }
        isLoading = true
        if response.isEmpty {
            showPlaceholder(.loading())
        }
        Task {
            defer {
                isLoading = false
                refresh.endRefreshing()
            }
            do {
                response = try await NetworkService.shared.getNews()
                news.reloadData()
                if response.isEmpty {
                    var empty = UIContentUnavailableConfiguration.empty()
                    empty.image = UIImage(systemName: "newspaper")
                    empty.text = "No news right now"
                    showPlaceholder(empty)
                } else {
                    contentUnavailableConfiguration = nil
                }
            } catch {
                showError(error)
            }
        }
    }

    private func showError(_ error: Error) {
        // A failed refresh keeps the news that are already on screen.
        guard response.isEmpty else {
            let alert = UIAlertController(title: "Can't refresh news", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        var failure = UIContentUnavailableConfiguration.empty()
        failure.image = UIImage(systemName: "wifi.exclamationmark")
        failure.text = "Can't load news"
        failure.secondaryText = error.localizedDescription
        failure.button = .bordered()
        failure.button.title = "Try Again"
        failure.button.baseForegroundColor = .white
        failure.buttonProperties.primaryAction = UIAction { [weak self] _ in
            self?.getNews()
        }
        showPlaceholder(failure)
    }

    // The gradient is dark in both appearances, so label colors would not be readable here.
    private func showPlaceholder(_ configuration: UIContentUnavailableConfiguration) {
        var configuration = configuration
        configuration.textProperties.color = .white
        configuration.secondaryTextProperties.color = .lightGray
        configuration.imageProperties.tintColor = .lightGray
        contentUnavailableConfiguration = configuration
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        news.delegate = self
        news.dataSource = self
        // Assigned to `refreshControl` it never shows or fires here (the navigation bar is hidden).
        news.addSubview(refresh)

        getNews()
        setupNavigationItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
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
        cell.newsHeader.text = article.title
        cell.newsSource.text = article.source?.name
        cell.newsDescription.text = article.text
        cell.mainImage.layer.cornerRadius = 15
        cell.mainImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.mainImage.sd_setImage(with: article.imageURL, placeholderImage: UIImage(named: "Placeholder"), completed: nil)

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
        gradient.frame = view.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradient, at: 0)
    }


    private func setupNavigationItem() {
        self.navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
    }

}

