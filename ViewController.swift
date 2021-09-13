//
//  ViewController.swift
//  image_load_demo
//
//  Created by Max Petrov on 30.08.2021.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var networkService: NetworkService!
    var dbManger: DBManager!
    let queue = DispatchQueue.global(qos: .utility)
    var numberOfSongs : [DetailedTrackInfo] = []
    var reuseIdentifier = "track cell"
    //var images: [UIImage?] = []
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    @IBOutlet weak var favouritesTabBarItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        dbManger = DBManagerImpl.shared
        networkService = NetworkService()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        searchBar.searchTextField.textColor = UIColor.white
        downloadInfo("music")
    }
    
    

    private func downloadInfo(_ searchTerms: String?)  {
        var stringToURL = ""
        if searchTerms == "" {
            stringToURL = "https://itunes.apple.com/search?term=music&limit=25&attributes=artistTerm+songTerm."
        } else {
            stringToURL = "https://itunes.apple.com/search?term=\(searchTerms ?? "")&media=music&limit=25&attributes=artistTerm+songTerm."
        }
        tableView.isHidden = true
        activityIndicator.startAnimating()
        networkService.downloadInfo(stringToURL) { result in
            self.tableView.isHidden = false
            self.activityIndicator.isHidden = true
            self.numberOfSongs = result
            self.tableView.reloadData()
            let favList = self.dbManger.obtain().map { $0.trackId}
            self.numberOfSongs.forEach { element in
                if favList.contains(element.trackId) {
                    element.isFavourite = true
                }
            }
        }
    }
     
    private func getImage(for index: Int) -> UIImage? {
        if let data = numberOfSongs[index].imageData, let image = UIImage(data: data)  {
            return image
        } else {
            networkService.downloadImage(numberOfSongs[index].artworkUrl60) { imageData in
                self.numberOfSongs[index].imageData = imageData
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
            return nil
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
   
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        cell.trackNameLabel.text = numberOfSongs[indexPath.row].trackName
        cell.artistNameLabel.text = numberOfSongs[indexPath.row].artistName
        
        cell.trackLogo.image = getImage(for: indexPath.row)
        if  cell.trackLogo.image == nil {
            cell.cellActivityIndicator.startAnimating()
        } else {
            cell.cellActivityIndicator.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondViewController = storyboard.instantiateViewController(identifier: "SecondViewController") as? SecondViewController else {return}
        secondViewController.networkServices = networkService
        secondViewController.trackInfo = numberOfSongs[indexPath.row]
        secondViewController.modalPresentationStyle = .fullScreen
        present(secondViewController, animated: true, completion: nil)
    }
    
    
}

extension ViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        let searchInfo = searchBar.text
        let adjustedString = searchInfo?.replacingOccurrences(of: " ", with: "+")
    
        numberOfSongs = []
        tableView.reloadData()
        downloadInfo(adjustedString)

    }
    
    
}



