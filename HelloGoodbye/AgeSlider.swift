//
//  AgeSlider.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/14.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  A custom slider that allows users to adjust their age.

 */

import UIKit

@objc(AAPLAgeSlider)
class AgeSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = StyleUtilities.foregroundColor
        minimumValue = 18
        maximumValue = 120
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var accessibilityValue: String? {
        get {
            // Return the age as a number, not as a percentage
            return NumberFormatter.localizedString(from: value as NSNumber, number: .decimal)
        }
        set {
            super.accessibilityValue = newValue
        }
    }
    
    override func accessibilityIncrement() {
        value += 1
        sendActions(for: .valueChanged)
    }
    
    override func accessibilityDecrement() {
        value -= 1
        sendActions(for: .valueChanged)
    }
    
}
