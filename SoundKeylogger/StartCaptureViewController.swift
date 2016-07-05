//
//  StartCaptureViewController.swift
//  SoundKeylogger
//
//  Created by Rodrigo Alves on 7/5/16.
//  Copyright © 2016 Rodrigo Alves. All rights reserved.
//

import UIKit
import AVFoundation

class StartCaptureViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate  {
    
    // MARK: - Outlets
    @IBOutlet weak var startCaptureButton: UIButton!
    
    // MARK: - Variables
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.tintColor = Shared.Colors.pink
        self.navigationController?.navigationBar.barTintColor = Shared.Colors.dark
        
        self.navigationController!.navigationBar.titleTextAttributes = Shared.LayoutHelpers.navigationBarTitleAttributes
        self.startCaptureButton.layer.borderColor = Shared.Colors.green.CGColor
        
        self.startCaptureButton.layer.borderWidth = 2.0
        
        self.startCaptureButton.layer.cornerRadius = self.startCaptureButton.frame.size.width/5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupAudioEnvironment() {
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                .UserDomainMask, true)
        
        if let docsDir = dirPaths[0] as? String {
        }
    }
    
    @IBAction func performCapture(sender: UIButton) {
        
        
    }
}

