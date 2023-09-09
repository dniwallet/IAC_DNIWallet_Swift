//
//  IAC_DNIWallet.swift
//  IAC_DNIWallet
//
//  Created by DNIWallet on 22/4/23.
//  Copyright © DNIWallet All rights reserved.
//

import Foundation
import IACCore

public let dniWalletBasicScheme  = "x-callback-dniwallet"
public let dniWalletPlusScheme   = "x-callback-dniwalletplus"
public let dniWalletDeepLink     = "dniwallet"

/// IACClient for DNI Wallet
public class DNIWalletBasicIACClient: IACClient {
    public init() {
        super.init(scheme: dniWalletBasicScheme)
    }
}

/// IACClient for DNI Wallet+
public class DNIWalletPlusIACClient: IACClient {
    public init() {
        super.init(scheme: dniWalletPlusScheme)
    }
}

/// IACClient for DNI Wallet+ & DNI Wallet
public class DNIWalletIACClient: IACClient {
    public init() {
        // By default uses dniwallet://
        var schemeFound: String = dniWalletDeepLink
        
        // Try to check if exists x-callback-dniwalletplus://
        if IACClient(scheme: dniWalletPlusScheme).isAppInstalled() {
            schemeFound = dniWalletPlusScheme
        }
        
        // Try to check if exists x-callback-dniwallet://
        else if IACClient(scheme: dniWalletBasicScheme).isAppInstalled() {
            schemeFound = dniWalletBasicScheme
        }
        
        // initializes with the best schema found
        super.init(scheme: schemeFound)
    }
}

// Extension to run a DNI Wallet process (using organizationID, processID and optional externalID)
public extension DNIWalletIACClient {
    func runProcess(organizationID: String, processID: String, externalID: String? = nil, dni: String? = nil, params: [String:String] = [:], handler: IACResultHandler? = nil) {
        var params = params
        params["cid"] = organizationID
        params["pid"] = processID
        if let externalID {
            params["eid"] = externalID
        }
        if let dni {
            params["dni"] = dni
        }
        do {
            if let handler = handler {
                try performAction("runProcess", parameters: params) { handler($0) }
            } else {
                try performAction("open", parameters: params)
            }
        } catch {
            handler?(.failure(error as NSError))
        }
    }
}
