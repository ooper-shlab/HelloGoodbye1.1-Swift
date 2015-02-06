//
//  AAPLPhotoBackgroundViewController.swift
//  HelloGoodbye
//
//  Created by 開発 on 2014/08/14.
//  Copyright (c) 2014年 Apple. All rights reserved.
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
        let viewAspectRatio = CGRectGetWidth(bounds) / CGRectGetHeight(bounds)
        if viewAspectRatio > imageAspectRatio {
            // Let the background run off the top and bottom of the screen, so it fills the width
            let scaledSize = CGSizeMake(CGRectGetWidth(bounds), CGRectGetWidth(bounds) / imageAspectRatio)
            backgroundView.frame = CGRectMake(0.0, (CGRectGetHeight(bounds) - scaledSize.height) / 2.0, scaledSize.width, scaledSize.height)
        } else {
            // Let the background run off the left and right of the screen, so it fills the height
            let scaledSize = CGSizeMake(imageAspectRatio * CGRectGetHeight(bounds), CGRectGetHeight(bounds))
            backgroundView.frame = CGRectMake((CGRectGetWidth(bounds) - scaledSize.width) / 2.0, 0.0, scaledSize.width, scaledSize.height)
        }
    }
    
    private func backgroundImageDidSet(oldValue: UIImage!) {
        if( oldValue !== backgroundImage ) {
            backgroundView?.image = backgroundImage
        }
    }
    
}