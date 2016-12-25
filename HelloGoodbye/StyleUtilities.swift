//
//  AAPLStyleUtilities.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/12.
//
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
    
    class var foregroundColor: UIColor {
        return UIColor(red:75.0/255, green:35.0/255, blue:106.0/255, alpha:1.0)
    }
    
    class var overlayColor: UIColor {
        if UIAccessibilityIsReduceTransparencyEnabled() {
            return UIColor.white
        }
        return UIColor(white:1.0, alpha:0.8)
    }
    
    class var cardBorderColor: UIColor {
        return foregroundColor
    }
    
    class var cardBackgroundColor: UIColor {
        return UIColor.white
    }
    
    class var detailColor: UIColor {
        if UIAccessibilityDarkerSystemColorsEnabled() {
            return UIColor.black
        }
        return UIColor.gray
    }
    
    class var detailOnOverlayColor: UIColor {
        return UIColor.black
    }
    
    class var detailOnOverlayPlaceholderColor: UIColor {
        return UIColor.darkGray
    }
    
    class var previewTabLabelColor: UIColor {
        return UIColor.white
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
    
    static var overlayRoundedRectImage: UIImage = {
        let imageSize = CGSize(width: 2 * overlayCornerRadius, height: 2 * overlayCornerRadius)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
            
        let roundedRect = UIBezierPath(roundedRect:CGRect(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height), cornerRadius:OverlayCornerRadius)
            overlayColor.set()
            roundedRect.fill()
            
            var roundedRectImage = UIGraphicsGetImageFromCurrentImageContext()!
            roundedRectImage = roundedRectImage.resizableImage(withCapInsets: UIEdgeInsetsMake(OverlayCornerRadius, OverlayCornerRadius, OverlayCornerRadius, OverlayCornerRadius))
        return roundedRectImage
    }()
    
    class func overlayRoundedRectButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(foregroundColor, for: .normal)
        button.titleLabel!.font = largeFont
        button.setBackgroundImage(overlayRoundedRectImage, for:.normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(ButtonVerticalContentInset, ButtonHorizontalContentInset, ButtonVerticalContentInset, ButtonHorizontalContentInset)
        return button
    }
    
    class var fontName: String {
        if UIAccessibilityIsBoldTextEnabled() {
            return "Avenir-Medium"
        }
        return "Avenir-Light"
    }
    
    class var standardFont: UIFont {
        return UIFont(name: fontName, size:14.0)!
    }
    
    class var largeFont: UIFont {
        return UIFont(name: fontName, size: 18.0)!
    }
    
    class func standardLabel() -> UILabel {
        let label = UILabel()
        label.textColor = foregroundColor
        label.font = standardFont
        label.numberOfLines = 0 // don't force it to be a single line
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    class func detailLabel() -> UILabel {
        let label = standardLabel()
        label.textColor = detailColor
        return label
    }
    
}
