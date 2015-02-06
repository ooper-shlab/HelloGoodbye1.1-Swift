//
//  AgeSlider.swift
//  HelloGoodbye
//
//  Created by 開発 on 2014/08/14.
//  Copyright (c) 2014年 Apple. All rights reserved.
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
        tintColor = StyleUtilities.foregroundColor()
        minimumValue = 18
        maximumValue = 120
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init() {
        super.init()
    }

    func accessibilityValue() -> String {
    // Return the age as a number, not as a percentage
        return NSNumberFormatter.localizedStringFromNumber(value, numberStyle: .DecimalStyle)
    }

    override func accessibilityIncrement() {
        value++
        sendActionsForControlEvents(.ValueChanged)
    }

    override func accessibilityDecrement() {
        value--
        sendActionsForControlEvents(.ValueChanged)
    }

}