//
//  Shared.swift
//  SoundKeylogger
//
//  Created by Rodrigo Alves on 7/5/16.
//  Copyright © 2016 Rodrigo Alves. All rights reserved.
//

import UIKit
import Firebase

struct Shared {
    struct FirebaseInstance {
        static let storage = FIRStorage.storage()
        static let storageRef = storage.reference(forURL: "gs://captures")
    }
    
    struct Colors {
        static let dark = UIColor(rgba: Color.Dark.rawValue)
        static let pink = UIColor(rgba: Color.Pink.rawValue)
        static let darkGray = UIColor(rgba: Color.LightGray.rawValue)
        static let babyBlue = UIColor(rgba: Color.BabyBlue.rawValue)
        static let white = UIColor.white()
        static let green = UIColor(rgba: Color.Green.rawValue)
    }
    
    struct LayoutHelpers {
        static let screenSize = UIScreen.main().bounds
        
        static let navigationBarTitleAttributes = [
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 20)!,
            NSForegroundColorAttributeName : UIColor.white()
        ]
        
        static let navigationBarFont = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 20)!]
    }
}
