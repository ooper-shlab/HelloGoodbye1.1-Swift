//
//  AAPLStartViewController.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/15.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  The first view controller in the application.  Shows the application logo and navigation buttons.

 */

import UIKit

private let ButtonToButtonVerticalSpacing: CGFloat = 10.0
private let LogoPadding: CGFloat = 30.0

@objc(AAPLStartViewController)
class StartViewController: AAPLPhotoBackgroundViewController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("HelloGoodbye", comment: "Title of the start page")
        backgroundImage = UIImage(named: "couple")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = view
        
        let logoOverlayView = UIView()
        logoOverlayView.backgroundColor = StyleUtilities.overlayColor()
        logoOverlayView.layer.cornerRadius = StyleUtilities.overlayCornerRadius
        logoOverlayView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logoOverlayView)
        
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.isAccessibilityElement = true
        logo.accessibilityLabel = NSLocalizedString("Hello goodbye, meet your match", comment: "Logo description")
        logo.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logo)
        
        let profileButton = roundedRectButtonWithTitle(NSLocalizedString("Profile", comment: "Title of the profile page"), action: #selector(StartViewController.showProfile))
        containerView.addSubview(profileButton)
        let matchesButton = roundedRectButtonWithTitle(NSLocalizedString("Matches", comment: "Title of the matches page"), action: #selector(StartViewController.showMatches))
        containerView.addSubview(matchesButton)
        
        var constraints: [NSLayoutConstraint] = []
        
        // Use dummy views space the top of the view, the logo, the buttons, and the bottom of the view evenly apart
        let topDummyView = addDummyViewToContainerView(containerView, alignedOnTopWithItem: topLayoutGuide, onBottomWithItem: logoOverlayView, constraints: &constraints)
        let middleDummyView = addDummyViewToContainerView(containerView, alignedOnTopWithItem: logoOverlayView, onBottomWithItem: profileButton, constraints: &constraints)
        let bottomDummyView = addDummyViewToContainerView(containerView, alignedOnTopWithItem: matchesButton, onBottomWithItem: bottomLayoutGuide, constraints: &constraints)
        constraints.append(NSLayoutConstraint(item: topDummyView, attribute: .Height, relatedBy: .Equal, toItem: middleDummyView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: middleDummyView, attribute: .Height, relatedBy: .Equal, toItem: bottomDummyView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        
        // Position the logo
        constraints +=
            [
                NSLayoutConstraint(item: logoOverlayView, attribute: .Top, relatedBy: .Equal, toItem: topDummyView, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logoOverlayView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logoOverlayView, attribute: .Bottom, relatedBy: .Equal, toItem: middleDummyView, attribute: .Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logo, attribute: .Top, relatedBy: .Equal, toItem: logoOverlayView, attribute: .Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logo, attribute: .Bottom, relatedBy: .Equal, toItem: logoOverlayView, attribute: .Bottom, multiplier: 1.0, constant: -LogoPadding),
                NSLayoutConstraint(item: logo, attribute: .Leading, relatedBy: .Equal, toItem: logoOverlayView, attribute: .Leading, multiplier: 1.0, constant: LogoPadding),
                NSLayoutConstraint(item: logo, attribute: .Trailing, relatedBy: .Equal, toItem: logoOverlayView, attribute: .Trailing, multiplier: 1.0, constant: -LogoPadding)
            ]
        
        // Position the profile button
        constraints.append(NSLayoutConstraint(item: profileButton, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: profileButton, attribute: .Top, relatedBy: .Equal, toItem: middleDummyView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        // Put the matches button below the profile button
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .Top, relatedBy: .Equal, toItem: profileButton, attribute: .Bottom, multiplier: 1.0, constant: ButtonToButtonVerticalSpacing))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .Bottom, relatedBy: .Equal, toItem: bottomDummyView, attribute: .Top, multiplier: 1.0, constant: 0.0))
        
        // Align the left and right edges of the two buttons and the logo
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .Leading, relatedBy: .Equal, toItem: profileButton, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .Trailing, relatedBy: .Equal, toItem: profileButton, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .Leading, relatedBy: .Equal, toItem: logoOverlayView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .Trailing, relatedBy: .Equal, toItem: logoOverlayView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        containerView.addConstraints(constraints)
    }
    
    private func addDummyViewToContainerView(containerView: UIView, alignedOnTopWithItem topItem:AnyObject!, onBottomWithItem bottomItem: AnyObject!, inout constraints: [NSLayoutConstraint]) -> UIView {
        let dummyView = UIView()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dummyView)
        
        // The horizontal layout of the dummy view does not matter, but for completeness, we give it a width of 0 and center it horizontally.
        constraints +=
            [
                NSLayoutConstraint(item: dummyView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .Top, relatedBy: .Equal, toItem: topItem, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomItem, attribute: .Top, multiplier: 1.0, constant: 0.0)
            ]
        return dummyView
    }
    
    private func roundedRectButtonWithTitle(title: String, action: Selector) -> UIButton {
        let button = StyleUtilities.overlayRoundedRectButton()
        button.setTitle(title, forState: .Normal)
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return button
    }
    
    func showProfile() {
        let profileViewController = ProfileViewController()
        navigationController!.pushViewController(profileViewController, animated: true)
    }
    
    func showMatches() {
        let matchesViewController = MatchesViewController()
        navigationController!.pushViewController(matchesViewController, animated: true)
    }
    
}