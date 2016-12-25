//
//  AAPLPhotoBackgroundViewController.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/14.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  A view controller that uses a photo as a background image.

 */

import UIKit

@objc(AAPLPhotoBackgroundViewController)
class AAPLPhotoBackgroundViewController: UIViewController {
    
    var backgroundImage: UIImage! {
        didSet {
            backgroundImageDidSet(oldValue)
        }
    }
    
    private var backgroundView: UIImageView!
    
    override func loadView() {
        let containerView = UIView()
        containerView.clipsToBounds = true
        
        backgroundView = UIImageView(image: backgroundImage)
        containerView.addSubview(backgroundView)
        
        view = containerView
    }
    
    override func viewWillLayoutSubviews() {
        let bounds = view.bounds
        let imageSize = backgroundView.image!.size
        let imageAspectRatio = imageSize.width / imageSize.height
        let viewAspectRatio = bounds.width / bounds.height
        if viewAspectRatio > imageAspectRatio {
            // Let the background run off the top and bottom of the screen, so it fills the width
            let scaledSize = CGSize(width: bounds.width, height: bounds.width / imageAspectRatio)
            backgroundView.frame = CGRect(x: 0.0, y: (bounds.height - scaledSize.height) / 2.0, width: scaledSize.width, height: scaledSize.height)
        } else {
            // Let the background run off the left and right of the screen, so it fills the height
            let scaledSize = CGSize(width: imageAspectRatio * bounds.height, height: bounds.height)
            backgroundView.frame = CGRect(x: (bounds.width - scaledSize.width) / 2.0, y: 0.0, width: scaledSize.width, height: scaledSize.height)
        }
    }
    
    private func backgroundImageDidSet(_ oldValue: UIImage!) {
        if( oldValue !== backgroundImage ) {
            backgroundView?.image = backgroundImage
        }
    }
    
}
