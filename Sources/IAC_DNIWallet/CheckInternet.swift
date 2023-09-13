//
//  CheckInternet.swift
//  IAC_DNIWallet
//
//  Created by DNIWallet on 22/4/23.
//  Copyright © DNIWallet All rights reserved.
//

import UIKit
import SystemConfiguration

public extension String {
    func localized() -> String {
        let language = Locale.preferredLanguages.first
        
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"), let bundle = Bundle(path: path) {
            let localizedString = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
            return localizedString
        } else {
            let defaultString = NSLocalizedString(self, comment: "")
            return defaultString
        }
    }
}

public extension UIViewController {
    
    func Alert (Title: String, Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil)) // retrybtn))
        self.present(alert, animated: true, completion: nil)
    }
    
    func AskInstall (Title: String, Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Install".localized(), style: .default, handler: { _ in
            UIApplication.shared.open(URL(string:"https://apps.apple.com/es/app/dni-wallet/id1645500619")!,options: [:], completionHandler: {_ in })
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

public class CheckInternet {
    public class func Connection() -> Bool{
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        #if DEBUG
        print("sockaddr=\(sockaddr.self)")
        #endif
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        #if DEBUG
        print("isReachable=\(isReachable) needsConnection=\(needsConnection)")
        #endif
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
