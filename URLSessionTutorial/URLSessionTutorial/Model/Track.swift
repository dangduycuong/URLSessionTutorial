//
//  Track.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import Foundation.NSURL

//
// MARK: - Track
//

/// Query service creates Track objects
class Track {
    //
    // MARK: - Constants
    //
    let artist: String
    let index: Int
    let name: String
    let previewURL: URL
    
    //
    // MARK: - Variables And Properties
    //
    var downloaded = false
    
    //
    // MARK: - Initialization
    //
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
}

