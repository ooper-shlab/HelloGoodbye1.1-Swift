//
//  AAPLMatchesViewController.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/14.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  The matches view controller in the application.  Allows users to view matches suggested by the app.

 */

import UIKit

private let HelloGoodbyeVerticalMargin: CGFloat = 5.0
private let SwipeAnimationDuration: TimeInterval = 0.5
private let ZoomAnimationDuration: TimeInterval = 0.3
private let FadeAnimationDuration: TimeInterval = 0.3

@objc(AAPLMatchesViewController)
class MatchesViewController: AAPLPhotoBackgroundViewController {
    
    private var cardView: CardView!
    private var swipeInstructionsView: UIView!
    private var allMatchesViewedExplanatoryView: UIView!
    
    private var cardViewVerticalConstraints: [NSLayoutConstraint] = []
    
    // Array of AAPLPersons
    private var matches: [Person] = []
    private var currentMatchIndex: Int = 0
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        let serializedMatches = NSArray(contentsOfFile: Bundle.main.path(forResource: "matches", ofType: "plist")!)! as! [[String: Any]]
        //println(serializedMatches)
        self.matches = serializedMatches.map { Person(dictionary: $0) }
        title = NSLocalizedString("Matches", comment: "Title of the matches page")
        
        backgroundImage = UIImage(named: "dessert")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = view!
        var constraints: [NSLayoutConstraint] = []
        
        // Show instructions for how to say hello and goodbye
        swipeInstructionsView = addSwipeInstructions(toContainer: containerView, constraints: &constraints)
        
        // Add a dummy view to center the card between the explanatory view and the bottom layout guide
        let dummyView = addDummyView(toContainer: containerView, topItem: swipeInstructionsView, bottomItem: bottomLayoutGuide, constraints: &constraints)
        
        // Create and add the card
        let cardView = addCardView(to: containerView)
        
        // Define the vertical positioning of the card
        // These constraints will be removed when the card animates off screen
        cardViewVerticalConstraints = [
                NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal, toItem: dummyView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: swipeInstructionsView, attribute: .bottom, multiplier: 1.0, constant: HelloGoodbyeVerticalMargin)
        ]
        constraints += cardViewVerticalConstraints
        
        // Ensure that the card is centered horizontally within the container view, and doesn't exceed its width
        constraints +=
            [
                NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: cardView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: containerView, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: cardView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: .right, multiplier: 1.0, constant: 0.0)
            ]
        
        // When the matches run out, we'll show this message
        allMatchesViewedExplanatoryView = addAllMatchesViewExplanatoryView(toContainer: containerView, constraints: &constraints)
        
        containerView.addConstraints(constraints)
    }
    
    private func addDummyView(toContainer containerView: UIView!, topItem: AnyObject!, bottomItem: AnyObject!, constraints: inout [NSLayoutConstraint]) -> UIView! {
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
    
    private func addCardView(to containerView: UIView) -> CardView {
        let cardView = CardView()
        cardView.update(person: currentMatch())
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView = cardView
        containerView.addSubview(cardView)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MatchesViewController.handleSwipeUp(_:)))
        swipeUpRecognizer.direction = .up
        cardView.addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MatchesViewController.handleSwipeDown(_:)))
        swipeDownRecognizer.direction = .down
        cardView.addGestureRecognizer(swipeDownRecognizer)
        
        let helloAction = UIAccessibilityCustomAction(name: NSLocalizedString("Say hello", comment: "Accessibility action to say hello"), target: self, selector: #selector(MatchesViewController.sayHello))
        let goodbyeAction = UIAccessibilityCustomAction(name: NSLocalizedString("Say goodbye", comment: "Accessibility action to say goodbye"), target: self, selector: #selector(MatchesViewController.sayGoodbye))
        for element in cardView.accessibilityElements as! [UIView] {
            element.accessibilityCustomActions = [helloAction, goodbyeAction]
        }
        
        return cardView
    }
    
    private func addOverlayView(toContainer containerView: UIView) ->UIView {
        let overlayView = UIView()
        overlayView.backgroundColor = StyleUtilities.overlayColor
        overlayView.layer.cornerRadius = StyleUtilities.overlayCornerRadius
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(overlayView)
        return overlayView
    }
    
    let UILayoutPriorityRequired:Float = 1000
    private func addSwipeInstructions(toContainer containerView: UIView, constraints: inout [NSLayoutConstraint]) -> UIView {
        let overlayView = addOverlayView(toContainer: containerView)
        
        let swipeInstructionsLabel = StyleUtilities.standardLabel()
        swipeInstructionsLabel.font = StyleUtilities.largeFont
        overlayView.addSubview(swipeInstructionsLabel)
        swipeInstructionsLabel.text = NSLocalizedString("Swipe ↑ to say \"Hello!\"\nSwipe ↓ to say \"Goodbye...\"", comment: "Instructions for the Matches page")
        swipeInstructionsLabel.accessibilityLabel = NSLocalizedString("Swipe up to say \"Hello!\"\nSwipe down to say \"Goodbye\"", comment: "Accessibility instructions for the Matches page")
        
        let overlayMargin = StyleUtilities.overlayMargin
        let topMarginConstraint = NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: overlayMargin)
        topMarginConstraint.priority = UILayoutPriority(UILayoutPriority.required.rawValue - 1)
        constraints.append(topMarginConstraint)
        // Position the label inside the overlay view
        constraints.append(NSLayoutConstraint(item: swipeInstructionsLabel, attribute: .top, relatedBy: .equal, toItem: overlayView, attribute: .top, multiplier: 1.0, constant: HelloGoodbyeVerticalMargin))
        constraints.append(NSLayoutConstraint(item: swipeInstructionsLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: swipeInstructionsLabel, attribute: .bottom, multiplier: 1.0, constant: HelloGoodbyeVerticalMargin))
        
        // Center the overlay view horizontally
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1.0, constant: overlayMargin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1.0, constant: -overlayMargin))
        return overlayView
    }
    
    
    private func addAllMatchesViewExplanatoryView(toContainer containerView: UIView!, constraints: inout [NSLayoutConstraint]) -> UIView! {
        let overlayView = addOverlayView(toContainer: containerView)
        
        // Start out hidden
        // This view will become visible once all matches have been viewed
        overlayView.alpha = 0.0
        
        let label = StyleUtilities.standardLabel()
        label.font = StyleUtilities.largeFont
        label.text = NSLocalizedString("Stay tuned for more matches!", comment: "Shown when all matches have been viewed")
        overlayView.addSubview(label)
        
        // Center the overlay view
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // Position the label in the overlay view
        constraints.append(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: overlayView, attribute: .top, multiplier: 1.0, constant: StyleUtilities.contentVerticalMargin))
        constraints.append(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .bottom, multiplier: 1.0, constant: -StyleUtilities.contentVerticalMargin))
        constraints.append(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: overlayView, attribute: .leading, multiplier: 1.0, constant: StyleUtilities.contentHorizontalMargin))
        constraints.append(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: 1.0, constant: -StyleUtilities.contentHorizontalMargin))
        return overlayView
    }
    
    private func currentMatch() -> Person? {
        var currentMatch: Person? = nil
        if currentMatchIndex < matches.count {
            currentMatch = (matches[currentMatchIndex])
        }
        return currentMatch
    }
    
    private func zoomCardIntoView() {
        cardView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: ZoomAnimationDuration) {
            self.cardView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateCardOffScreen(toTop: Bool, completion: (()->Void)?) {
        var offScreenConstraint: NSLayoutConstraint? = nil
        if toTop {
            offScreenConstraint = NSLayoutConstraint(item: cardView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        } else {
            offScreenConstraint = NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: SwipeAnimationDuration, animations: {
            // Slide the card off screen
            self.view.removeConstraints(self.cardViewVerticalConstraints)
            self.view.addConstraint(offScreenConstraint!)
            self.view.layoutIfNeeded()
            }) {finished in
                // Bring the card back into view
                self.view.removeConstraint(offScreenConstraint!)
                self.view.addConstraints(self.cardViewVerticalConstraints)
                completion?()
        }
    }
    
    private func fadeCardIntoView() {
        cardView.alpha = 0.0
        UIView.animate(withDuration: FadeAnimationDuration) {
            self.cardView.alpha = 1.0
        }
    }
    
    private func animateCards(forHello: Bool) {
        animateCardOffScreen(toTop: forHello) {
            self.currentMatchIndex += 1
            if let nextMatch = self.currentMatch() {
                // Show the next match's profile in the card
                self.cardView.update(person: nextMatch)
                
                // Ensure that the view's layout is up to date before we animate it
                self.view.layoutIfNeeded()
                
                if UIAccessibilityIsReduceMotionEnabled() {
                    // Fade the card into view
                    self.fadeCardIntoView()
                } else {
                    // Zoom the new card from a tiny point into full view
                    self.zoomCardIntoView()
                }
            } else {
                // Hide the card
                self.cardView.isHidden = true
                
                // Fade in the "Stay tuned for more matches" blurb
                UIView.animate(withDuration: FadeAnimationDuration) {
                    self.swipeInstructionsView.alpha = 0.0
                    self.allMatchesViewedExplanatoryView.alpha = 1.0
                }
            }
            
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    @discardableResult
    @objc private func sayHello() -> Bool {
        animateCards(forHello: true)
        return true
    }
    
    @discardableResult
    @objc private func sayGoodbye() ->Bool {
        animateCards(forHello: false)
        return true
    }
    
    let UIGestureRecognizerStateRecognized = UIGestureRecognizerState.ended
    @objc func handleSwipeUp(_ gestureRecognizer: UISwipeGestureRecognizer!) {
        if gestureRecognizer.state == UIGestureRecognizerStateRecognized {
            sayHello()
        }
    }
    
    @objc func handleSwipeDown(_ gestureRecognizer: UISwipeGestureRecognizer!) {
        if gestureRecognizer.state == UIGestureRecognizerStateRecognized {
            sayGoodbye()
        }
    }
    
}
