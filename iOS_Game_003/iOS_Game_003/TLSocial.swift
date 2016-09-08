//
//  TLSocial.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 08.09.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//
import SpriteKit
import Social

/// URLs
private struct URL {
    static let iTunesApp = NSURL(string: "apps://itunes.apple.com")
    static let twitterApp = NSURL(string: "twitter://")
    static let twitterWeb = NSURL(string: "https://twitter.com/")
    static let facebookApp = NSURL(string: "facebook://")
    static let facebookWeb = NSURL(string: "https://facebook.com/")
}

/// Text strings
private struct TextString {
    static let shareSheetText = "Can you beat my score"
    static let error = "Error"
    static let enableSocial = "Please sign in to your account first"
    static let settings = "Settings"
    static let ok = "OK"
}

/// Social
protocol TLSocial {}
extension TLSocial where Self: SKScene {
    
    /// Open twitter
    func openTwitter() {
        guard let twitterApp = URL.twitterApp else { return }
        guard let twitterWeb = URL.twitterWeb else { return }
        
        if UIApplication.sharedApplication().canOpenURL(twitterApp){
            UIApplication.sharedApplication().openURL(twitterApp)
        } else {
            UIApplication.sharedApplication().openURL(twitterWeb)
        }
    }
    
    /// Open facebook
    func openFacebook() {
        guard let facebookApp = URL.facebookApp else { return }
        guard let facebookWeb = URL.facebookWeb else { return }
        
        if UIApplication.sharedApplication().canOpenURL(facebookApp){
            UIApplication.sharedApplication().openURL(facebookApp)
        } else {
            UIApplication.sharedApplication().openURL(facebookWeb)
        }
    }
    
    /// Share to twitter
    func shareToTwitter() {
        
        guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) else {
            showAlert()
            return
        }
        
        let twitterSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterSheet.completionHandler = { result in
            
            switch result {
                
            case .Cancelled:
                print("twitter message cancelled")
                break
                
            case .Done:
                print("twitter message complete")
                break
            }
        }
        
        let text = TextString.shareSheetText //
        twitterSheet.setInitialText(text) // share sheet text for twitter will not work anymore if app is installed
        self.view?.window?.rootViewController?.presentViewController(twitterSheet, animated: true, completion: nil)
    }
    
    /// Share to facebook
    func shareToFacebook() {
        
        guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) else {
            showAlert()
            return
        }
        
        let facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSheet.completionHandler = { result in
            
            switch result {
                
            case .Cancelled:
                print("facebook message cancelled")
                break
                
            case .Done:
                print("facebook message complete")
                break
            }
        }
        
        let text = TextString.shareSheetText //
        facebookSheet.setInitialText(text) // share sheet text for twitter will not work anymore if app is installed
        self.view?.window?.rootViewController?.presentViewController(facebookSheet, animated: true, completion: nil)
    }
    
    /// Show alert
    private func showAlert() {
        let alertController = UIAlertController(title: TextString.error, message: TextString.enableSocial, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: TextString.ok, style: .Cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: TextString.settings, style: .Default) { _ in
            
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        
        self.view?.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
}