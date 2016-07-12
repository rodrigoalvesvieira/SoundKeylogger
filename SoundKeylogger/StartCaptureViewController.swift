//
//  StartCaptureViewController.swift
//  SoundKeylogger
//
//  Created by Rodrigo Alves on 7/5/16.
//  Copyright © 2016 Rodrigo Alves. All rights reserved.
//

import UIKit
import AVFoundation
import MRProgress

class StartCaptureViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate  {
    
    // MARK: - Outlets
    @IBOutlet weak var startCaptureButton: UIButton!
    
    @IBOutlet weak var loadingAreaView: UIView!
    
    // MARK: - Variables
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var newCaptureURL: URL?
    var downloadURL: String?
    
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
        NSLog("startRecording() chamado")
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let audioFilename = documentsDirectory.stringByAppendingPathComponent(pathComponent: "recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        newCaptureURL = audioURL as URL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        MRProgressOverlayView.showOverlayAdded(to: self.loadingAreaView, animated: true)
        
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
    
    func sendToServer(audioUrl: NSURL) {
        NSLog("sendToServer() chamado")
        
        let storageRef = Shared.FirebaseInstance.storage.reference()
        
        let stringFromDate = Date().iso8601
        if let dateFromString = stringFromDate.dateFromISO8601 {
            let fileName = "recording-\(dateFromString.iso8601).m4a"
            
            NSLog("Nome do arquivo no servidor remoto é \(fileName)")
            let audioRef = storageRef.child(fileName)
            
            audioRef.putFile(audioUrl as URL, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    NSLog("Ocorreu um erro: \(error.debugDescription)")
                    
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    
                    if let downloadURL = metadata?.downloadURL() {
                        let rawDownloadURL = "\(downloadURL)"
                        
                        self.downloadURL = rawDownloadURL

                        NSLog("URL de download é \(downloadURL)")
                        self.displaySuccessMessage(remoteFileName: rawDownloadURL)
                    }
                }
            }

        }
    }
    
    func displayErrorMessage() {
        let alertController = UIAlertController(title: "Oops!", message:"Falha ao tentar capturar áudio!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displaySuccessMessage(remoteFileName: String) {
        let alertController = UIAlertController(title: "Áudio capturado com sucesso!", message: "Pode ser recuperado na URL: \(remoteFileName).", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        let openLinkAction = UIAlertAction(title: "Seguir link", style: .default, handler: openURL)
        alertController.addAction(openLinkAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openURL(alert: UIAlertAction!) {
        if let url = self.downloadURL {
            NSLog("Abrindo url...")
            UIApplication.shared().openURL(URL(string: url)!)
        }
    }
    
    func finishRecording(success: Bool) {
        NSLog("finishRecording() chamado")
        
        audioRecorder.stop()
        audioRecorder = nil
        
        MRProgressOverlayView.dismissOverlay(for: self.loadingAreaView, animated: true)
        
        if success {
            startCaptureButton.setTitle("Reiniciar Captura", for: .normal)
            
            if let captureURL = newCaptureURL {
                NSLog("Áudio capturado com sucesso \(captureURL)")
                self.sendToServer(audioUrl: captureURL)
            }
            
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
