//
//  TrackCell.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell)
    func downloadTapped(_ cell: TrackCell)
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
}

class TrackCell: BaseTableViewCell {
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //
    // MARK: - Variables And Properties
    //
    
    /// Delegate identifies track for this cell, then
    /// passes this to a download service method.
    //    var delegate: TrackCellDelegate?
    
    //
    // MARK: - IBActions
    //
    @IBAction func cancelTapped(_ sender: AnyObject) {
        if let delegate = delegate as? TrackCellDelegate {
            delegate.cancelTapped(self)
        }
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
        if let delegate = delegate as? TrackCellDelegate {
            delegate.downloadTapped(self)
        }
    }
    
    @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
        if let delegate = delegate as? TrackCellDelegate {
            if pauseButton.titleLabel?.text == "Pause" {
                delegate.pauseTapped(self)
            } else {
                delegate.resumeTapped(self)
            }
        }
    }
    
    //
    // MARK: - Internal Methods
    //
    // TODO 12
    func configure(track: Track, downloaded: Bool, download: Download?) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
        
        // Show/hide download controls Pause/Resume, Cancel buttons, progress info.
        // TODO 14
        var showDownloadControls = false
        
        // Non-nil Download object means a download is in progress.
        // TODO 15
        if let download = download {
            showDownloadControls = true
            let title = download.isDownloading ? "Pause" : "Resume"
            pauseButton.setTitle(title, for: .normal)
            
            progressLabel.text = download.isDownloading ? "Downloading..." : "Paused"
            
        }
        
        pauseButton.isHidden = !showDownloadControls
        cancelButton.isHidden = !showDownloadControls
        
        progressView.isHidden = !showDownloadControls
        progressLabel.isHidden = !showDownloadControls
        
        
        
        // If the track is already downloaded, enable cell selection and hide the Download button.
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        //        downloadButton.isHidden = downloaded
        downloadButton.isHidden = downloaded || showDownloadControls
        
    }
    
    // TODO 16
    func updateDisplay(progress: Float, totalSize : String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
}
