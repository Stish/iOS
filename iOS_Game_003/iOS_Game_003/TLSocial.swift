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
    static let iTunesApp = Foundation.URL(string: "apps://itunes.apple.com")
    static let twitterApp = Foundation.URL(string: "twitter://")
    static let twitterWeb = Foundation.URL(string: "https://twitter.com/")
    static let facebookApp = Foundation.URL(string: "facebook://")
    static let facebookWeb = Foundation.URL(string: "https://facebook.com/")
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
        
        if UIApplication.shared.canOpenURL(twitterApp){
            UIApplication.shared.openURL(twitterApp)
        } else {
            UIApplication.shared.openURL(twitterWeb)
        }
    }
    
    /// Open facebook
    func openFacebook() {
        guard let facebookApp = URL.facebookApp else { return }
        guard let facebookWeb = URL.facebookWeb else { return }
        
        if UIApplication.shared.canOpenURL(facebookApp){
            UIApplication.shared.openURL(facebookApp)
        } else {
            UIApplication.shared.openURL(facebookWeb)
        }
    }
    
    /// Share to twitter
    func shareToTwitter() {
        
        guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
            showAlert()
            return
        }
        
        let twitterSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterSheet?.completionHandler = { result in
            
            switch result {
                
            case .cancelled:
                print("twitter message cancelled")
                break
                
            case .done:
                print("twitter message complete")
                break
            }
        }
        
        let text = TextString.shareSheetText //
        twitterSheet?.setInitialText(text) // share sheet text for twitter will not work anymore if app is installed
        self.view?.window?.rootViewController?.present(twitterSheet!, animated: true, completion: nil)
    }
    
    /// Share to facebook
    func shareToFacebook() {
        
        guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) else {
            showAlert()
            return
        }
        
        let facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSheet?.completionHandler = { result in
            
            switch result {
                
            case .cancelled:
                print("facebook message cancelled")
                break
                
            case .done:
                print("facebook message complete")
                break
            }
        }
        
        let text = TextString.shareSheetText //
        facebookSheet?.setInitialText(text) // share sheet text for twitter will not work anymore if app is installed
        facebookSheet?.add(Foundation.URL(string: text))
        self.view?.window?.rootViewController?.present(facebookSheet!, animated: true, completion: nil)
    }
    
    /// Show alert
    fileprivate func showAlert() {
        let alertController = UIAlertController(title: TextString.error, message: TextString.enableSocial, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: TextString.ok, style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: TextString.settings, style: .default) { _ in
            
            if let url = Foundation.URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
