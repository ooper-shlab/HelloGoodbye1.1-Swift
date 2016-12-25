//
//  PreviewLabel.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/13.
//
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
    
    func didActivate(_ previewLabel: PreviewLabel)
    
}

@objc(AAPLPreviewLabel)
class PreviewLabel: UILabel {
    
    weak var delegate: PreviewLabelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = NSLocalizedString("Preview", comment: "Name of the card preview tab")
        font = StyleUtilities.largeFont
        textColor = StyleUtilities.previewTabLabelColor
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func accessibilityActivate() -> Bool {
        delegate?.didActivate(self)
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
