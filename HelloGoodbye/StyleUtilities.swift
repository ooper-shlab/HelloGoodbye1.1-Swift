//
//  AAPLStyleUtilities.swift
//  HelloGoodbye
//
//  Created by 開発 on 2014/08/12.
//  Copyright (c) 2014年 Apple. All rights reserved.
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  A collection of methods related to the look and feel of the application.

 */

import UIKit

private let OverlayCornerRadius: CGFloat = 10.0
private let ButtonVerticalContentInset: CGFloat = 10.0
private let ButtonHorizontalContentInset: CGFloat = 10.0
private let OverlayMargin: CGFloat = 20.0
private let ContentVerticalMargin: CGFloat = 50.0
private let ContentHorizontalMargin: CGFloat = 30.0

@objc(AAPLStyleUtilities)
class StyleUtilities: NSObject {
    
    class func foregroundColor()->UIColor {
        return UIColor(red:75.0/255, green:35.0/255, blue:106.0/255, alpha:1.0)
    }
    
    class func overlayColor()->UIColor {
        if UIAccessibilityIsReduceTransparencyEnabled() {
            return UIColor.whiteColor()
        }
        return UIColor(white:1.0, alpha:0.8)
    }
    
    class func cardBorderColor()->UIColor {
        return foregroundColor()
    }
    
    class func cardBackgroundColor()->UIColor {
        return UIColor.whiteColor()
    }
    
    class func detailColor()->UIColor {
        if UIAccessibilityDarkerSystemColorsEnabled() {
            return UIColor.blackColor()
        }
        return UIColor.grayColor()
    }
    
    class func detailOnOverlayColor()->UIColor {
        return UIColor.blackColor()
    }
    
    class func detailOnOverlayPlaceholderColor()->UIColor {
        return UIColor.darkGrayColor()
    }
    
    class func previewTabLabelColor()->UIColor {
        return UIColor.whiteColor()
    }
    
    class var overlayCornerRadius: CGFloat {
        return OverlayCornerRadius
    }
    
    class var overlayMargin: CGFloat {
        return OverlayMargin
    }
    
    class var contentHorizontalMargin: CGFloat {
        return ContentHorizontalMargin
    }
    
    class var contentVerticalMargin: CGFloat {
        return ContentVerticalMargin
    }
    
    class func overlayRoundedRectImage()->UIImage! {
        struct Static {
            static var roundedRectImage: UIImage? = nil
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            let imageSize = CGSizeMake(2 * self.overlayCornerRadius, 2 * self.overlayCornerRadius);
            UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
            
            let roundedRect = UIBezierPath(roundedRect:CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), cornerRadius:OverlayCornerRadius)
            self.overlayColor().set()
            roundedRect.fill()
            
            Static.roundedRectImage = UIGraphicsGetImageFromCurrentImageContext()
            Static.roundedRectImage = Static.roundedRectImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(OverlayCornerRadius, OverlayCornerRadius, OverlayCornerRadius, OverlayCornerRadius))
        }
        return Static.roundedRectImage
    }
    
    class func overlayRoundedRectButton()-> UIButton! {
        let button = UIButton.buttonWithType(.Custom) as UIButton
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.setTitleColor(foregroundColor(), forState: .Normal)
        button.titleLabel!.font = largeFont
        button.setBackgroundImage(overlayRoundedRectImage(), forState:.Normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(ButtonVerticalContentInset, ButtonHorizontalContentInset, ButtonVerticalContentInset, ButtonHorizontalContentInset)
        return button
    }
    
    class var fontName: String {
        if UIAccessibilityIsBoldTextEnabled() {
            return "Avenir-Medium"
        }
        return "Avenir-Light"
    }
    
    class var standardFont: UIFont! {
        return UIFont(name:fontName, size:14.0)
    }
    
    class var largeFont: UIFont! {
        return UIFont(name: fontName, size: 18.0)
    }
    
    class var standardLabel: UILabel! {
        let label = UILabel()
        label.textColor = foregroundColor()
        label.font = standardFont
        label.numberOfLines = 0 // don't force it to be a single line
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        return label
    }
    
    class var detailLabel: UILabel! {
        let label = standardLabel
        label.textColor = detailColor()
        return label
    }
    
}