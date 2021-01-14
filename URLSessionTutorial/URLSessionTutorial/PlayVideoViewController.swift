//
//  PlayVideoViewController.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayVideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    @IBAction func tapPlayVideo(_ sender: Any) {
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
        let link = URL(string: "https://www.youtube.com/watch?v=liHYSE1aI3E")!
//        playVideo(url: link)
        
        let player = AVPlayer(url: link)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }

}
