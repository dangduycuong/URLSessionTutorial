//
//  SearchViewController.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

//
// MARK: - Search View Controller
//
class SearchViewController: BaseViewController {
    //
    // MARK: - Constants
    //
    
    /// Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let downloadService = DownloadService()
    let queryService = QueryService()
    
    
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //
    // MARK: - Variables And Properties
    //
    //MARK: Downloading a Track
    lazy var downloadsSession: URLSession = {
        let configuration =
            URLSessionConfiguration.background(withIdentifier:
                "com.raywenderlich.HalfTunes.bgSession")
        
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    var searchResults: [Track] = []
    
    //
    // MARK: - Internal Methods
    //
    @objc func dismissKeyboard() {
        //        searchBar.resignFirstResponder()
    }
    
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        
        let url = localFilePath(for: track.previewURL)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        tableView.register(TrackCell.nib(), forCellReuseIdentifier: TrackCell.identifier())
        setShadowView(view: searchView, cornerRadius: 20)
        searchTextField.delegate = self
        // TODO 7
        downloadService.downloadsSession = downloadsSession
    }
    
}

//
// MARK: - Search Bar Delegate
//
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonClicked(text: textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func searchButtonClicked(text: String?) {
        guard let searchText = text, !searchText.isEmpty else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self?.searchResults = results
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
}

//
// MARK: - Table View Data Source
//
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: TrackCell.identifier(),
                                                            for: indexPath) as! TrackCell
        // Delegate cell button tap events to this view controller.
        cell.delegate = self
        cell.indexPath = indexPath
        
        let track = searchResults[indexPath.row]
        // TODO 13
        cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
}

//
// MARK: - Table View Delegate
//
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When user taps cell, play the local file, if it's downloaded.
        
        let track = searchResults[indexPath.row]
        
        if track.downloaded {
            playDownload(track)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
// MARK: - Track Cell Delegate
//
extension SearchViewController: TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
        //        if let indexPath = cell.indexPath {
        //            let track = searchResults[indexPath.row]
        //            downloadService.startDownload(track)
        //            reload(indexPath.row)
        //        }
    }
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
}

// TODO 19
extension SearchViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                
                completionHandler()
            }
        }
    }
}


extension SearchViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("Finished downloading to \(location).")
        // 1
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        // 2
        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)
        // 3
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        // 4
        if let index = download?.track.index {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                                           with: .none)
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        // 1
        guard
            let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]
            else {
                return
        }
        // 2
        download.progress =
            Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // 3
        let totalSize =
            ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite,
                                      countStyle: .file)
        // 4
        DispatchQueue.main.async {
            if let trackCell =
                self.tableView.cellForRow(at: IndexPath(row: download.track.index,
                                                        section: 0)) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress,
                                        totalSize: totalSize)
            }
        }
    }
    
}
