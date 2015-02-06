//
//  PreviewLabel.swift
//  HelloGoodbye
//
//  Created by 開発 on 2014/08/13.
//  Copyright (c) 2014年 Apple. All rights reserved.
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  A custom label that appears on the Preview tab in the profile view controller.

 */

import UIKit

@objc(AAPLPreviewLabelDelegate)
protocol PreviewLabelDelegate: NSObjectProtocol {
    
    func didActivatePreviewLabel(previewLabel: PreviewLabel!)
    
}

@objc(AAPLPreviewLabel)
class PreviewLabel: UILabel {
    
    weak var delegate: PreviewLabelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = NSLocalizedString("Preview", comment: "Name of the card preview tab")
        font = StyleUtilities.largeFont
        textColor = StyleUtilities.previewTabLabelColor()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init() {
        super.init()
    }
    
    override func accessibilityActivate() -> Bool {
        delegate?.didActivatePreviewLabel(self)
        return false
    }
    
    override var accessibilityTraits:UIAccessibilityTraits {
        get {
            return super.accessibilityTraits | UIAccessibilityTraitButton
        }
        set {
            super.accessibilityTraits = newValue
        }
    }
    
}