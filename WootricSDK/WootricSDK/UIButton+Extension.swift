//
//  UIButton+Extension.swift
//  WootricSDK
//
//  Created by Vijay Radake on 11/05/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

import Foundation

@objc public extension UIButton
{
    func configureContentInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)
    {
//        if #available(iOS 15.0, *) {
//            self.configuration = .plain()
//            self.configuration?.contentInsets = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
//        } else {
            self.contentEdgeInsets = UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
//        }
    }
}
