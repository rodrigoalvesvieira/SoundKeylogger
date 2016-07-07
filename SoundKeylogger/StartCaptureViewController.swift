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
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        self.navigationController?.navigationBar.tintColor = Shared.Colors.pink
        self.navigationController?.navigationBar.barTintColor = Shared.Colors.dark
        
        self.navigationController!.navigationBar.titleTextAttributes = Shared.LayoutHelpers.navigationBarTitleAttributes
        self.startCaptureButton.layer.borderColor = Shared.Colors.green.cgColor
        
        self.startCaptureButton.layer.borderWidth = 2.0
        
        self.startCaptureButton.layer.cornerRadius = self.startCaptureButton.frame.size.width/5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    func loadRecordingUI() {
        NSLog("loadRecordingUI() called")
    }
    
    class func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
    func startRecording() {
        NSLog("startRecording() called")
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let audioFilename = documentsDirectory.stringByAppendingPathComponent(pathComponent: "recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioURL as URL, settings: settings)
            
            audioRecorder.delegate = self
            audioRecorder.record()
            
            startCaptureButton.setTitle("Parar", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func setupAudioEnvironment() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                DispatchQueue.main.asynchronously() {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
            self.displayErrorMessage()
        }
    }
    
    func displayErrorMessage() {
        let alert = UIAlertController(title: "Oops!", message:"Falha ao tentar capturar áudio!", preferredStyle: .alert)
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            startCaptureButton.setTitle("Reiniciar Captura", for: .normal)
            
            
        } else {
            startCaptureButton.setTitle("Iniciar Captura", for: .normal)
            // recording failed :(

            self.displayErrorMessage()
        }
    }
    
    //  iOS might stop your recording for some reason out of your control, such as if a phone call comes in. We are the delegate of the audio recorder, so if this situation crops up you'll be sent a audioRecorderDidFinishRecording() message that you can pass on to finishRecording() like this:
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    @IBAction func performCapture(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}
