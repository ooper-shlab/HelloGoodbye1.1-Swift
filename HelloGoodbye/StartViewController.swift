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
        
        let containerView = view!
        
        let logoOverlayView = UIView()
        logoOverlayView.backgroundColor = StyleUtilities.overlayColor
        logoOverlayView.layer.cornerRadius = StyleUtilities.overlayCornerRadius
        logoOverlayView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logoOverlayView)
        
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.isAccessibilityElement = true
        logo.accessibilityLabel = NSLocalizedString("Hello goodbye, meet your match", comment: "Logo description")
        logo.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logo)
        
        let profileButton = roundedRectButton(title: NSLocalizedString("Profile", comment: "Title of the profile page"), action: #selector(StartViewController.showProfile))
        containerView.addSubview(profileButton)
        let matchesButton = roundedRectButton(title: NSLocalizedString("Matches", comment: "Title of the matches page"), action: #selector(StartViewController.showMatches))
        containerView.addSubview(matchesButton)
        
        var constraints: [NSLayoutConstraint] = []
        
        // Use dummy views space the top of the view, the logo, the buttons, and the bottom of the view evenly apart
        let topDummyView = addDummyView(toContainer: containerView, alignedOnTopWithItem: topLayoutGuide, onBottomWithItem: logoOverlayView, constraints: &constraints)
        let middleDummyView = addDummyView(toContainer: containerView, alignedOnTopWithItem: logoOverlayView, onBottomWithItem: profileButton, constraints: &constraints)
        let bottomDummyView = addDummyView(toContainer: containerView, alignedOnTopWithItem: matchesButton, onBottomWithItem: bottomLayoutGuide, constraints: &constraints)
        constraints.append(NSLayoutConstraint(item: topDummyView, attribute: .height, relatedBy: .equal, toItem: middleDummyView, attribute: .height, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: middleDummyView, attribute: .height, relatedBy: .equal, toItem: bottomDummyView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        // Position the logo
        constraints +=
            [
                NSLayoutConstraint(item: logoOverlayView, attribute: .top, relatedBy: .equal, toItem: topDummyView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logoOverlayView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logoOverlayView, attribute: .bottom, relatedBy: .equal, toItem: middleDummyView, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logo, attribute: .top, relatedBy: .equal, toItem: logoOverlayView, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: logo, attribute: .bottom, relatedBy: .equal, toItem: logoOverlayView, attribute: .bottom, multiplier: 1.0, constant: -LogoPadding),
                NSLayoutConstraint(item: logo, attribute: .leading, relatedBy: .equal, toItem: logoOverlayView, attribute: .leading, multiplier: 1.0, constant: LogoPadding),
                NSLayoutConstraint(item: logo, attribute: .trailing, relatedBy: .equal, toItem: logoOverlayView, attribute: .trailing, multiplier: 1.0, constant: -LogoPadding)
            ]
        
        // Position the profile button
        constraints.append(NSLayoutConstraint(item: profileButton, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: profileButton, attribute: .top, relatedBy: .equal, toItem: middleDummyView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        // Put the matches button below the profile button
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .top, relatedBy: .equal, toItem: profileButton, attribute: .bottom, multiplier: 1.0, constant: ButtonToButtonVerticalSpacing))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .bottom, relatedBy: .equal, toItem: bottomDummyView, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        // Align the left and right edges of the two buttons and the logo
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .leading, relatedBy: .equal, toItem: profileButton, attribute: .leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .trailing, relatedBy: .equal, toItem: profileButton, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .leading, relatedBy: .equal, toItem: logoOverlayView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: matchesButton, attribute: .trailing, relatedBy: .equal, toItem: logoOverlayView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        containerView.addConstraints(constraints)
    }
    
    private func addDummyView(toContainer containerView: UIView, alignedOnTopWithItem topItem:AnyObject!, onBottomWithItem bottomItem: AnyObject!, constraints: inout [NSLayoutConstraint]) -> UIView {
        let dummyView = UIView()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dummyView)
        
        // The horizontal layout of the dummy view does not matter, but for completeness, we give it a width of 0 and center it horizontally.
        constraints +=
            [
                NSLayoutConstraint(item: dummyView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .top, relatedBy: .equal, toItem: topItem, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .bottom, relatedBy: .equal, toItem: bottomItem, attribute: .top, multiplier: 1.0, constant: 0.0)
            ]
        return dummyView
    }
    
    private func roundedRectButton(title: String, action: Selector) -> UIButton {
        let button = StyleUtilities.overlayRoundedRectButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc func showProfile() {
        let profileViewController = ProfileViewController()
        navigationController!.pushViewController(profileViewController, animated: true)
    }
    
    @objc func showMatches() {
        let matchesViewController = MatchesViewController()
        navigationController!.pushViewController(matchesViewController, animated: true)
    }
    
}
