//
//  ViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-15.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit
import AVKit


class StartViewController: UIViewController {
    
    @IBOutlet weak var imageBG: UIImageView!
    var videoPlayer:AVPlayer?
    
    var wentBack = 0
    var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var SignUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        // MARK:- When moving back to startview, hide the video
        imageBG.alpha = 0

        if wentBack == 1{
             imageBG.alpha = 1
        }
           
        setUp()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        //should stop video if we hit back button 
        wentBack = 1

    }
    
    @IBAction func signInPressed(_ sender: Any) {
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }

    
    
    //Testing video login
    func setUp() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "fridge_lady", ofType: "mp4")
        
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it and video item
        let url = URL(fileURLWithPath: bundlePath!)
        let item = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Change size
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.6, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        //stick it behind the buttons
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // play
        videoPlayer?.playImmediately(atRate: 1.2)
        
        // Use Notification Center to loop video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.playImmediately(atRate: 1.5)
        }
        
    }

}

