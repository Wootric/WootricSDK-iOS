//
//  UIApplication+Extension.swift
//  WootricSDK
//
//  Created by Vijay Radake on 11/05/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

import Foundation

@objc public extension UIApplication
{
    func openExternalUrl(_ url: URL, completion: ((Bool) -> Void)?)
    {
        if #available(iOS 10.0, *) {
            self.open(url, options: [:], completionHandler: completion)
        } else {
            let result = self.openURL(url)
            completion?(result)
        }
    }
    
    func applicationOrientation() -> UIInterfaceOrientation
    {
        if #available(iOS 13.0, *) {
            guard let orientation = self.windows.first?.windowScene?.interfaceOrientation else {
                return UIInterfaceOrientation.unknown
            }
            return orientation
        } else {
            return self.statusBarOrientation
        }
    }
}
