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
private let SwipeAnimationDuration: NSTimeInterval = 0.5
private let ZoomAnimationDuration: NSTimeInterval = 0.3
private let FadeAnimationDuration: NSTimeInterval = 0.3

@objc(AAPLMatchesViewController)
class MatchesViewController: AAPLPhotoBackgroundViewController {
    
    private var cardView: CardView!
    private var swipeInstructionsView: UIView!
    private var allMatchesViewedExplanatoryView: UIView!
    
    private var cardViewVerticalConstraints: NSArray!
    
    // Array of AAPLPersons
    private var matches: [Person] = []
    private var currentMatchIndex: Int = 0
    
    override init() {
        super.init()
        let serializedMatches = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("matches", ofType: "plist")!)!
        //println(serializedMatches)
        var matches: [Person] = []
        matches.reserveCapacity(serializedMatches.count)
        for serializedMatch in serializedMatches {
            if let matchDict = serializedMatch as? NSDictionary {
                let match = Person.personWithDictionary(/*serializedMatch*/matchDict)
                matches.append(match)
            }
        }
        title = NSLocalizedString("Matches", comment: "Title of the matches page")
        self.matches = matches
        
        backgroundImage = UIImage(named: "dessert")
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = view
        let constraints: NSMutableArray = NSMutableArray()
        
        // Show instructions for how to say hello and goodbye
        swipeInstructionsView = addSwipeInstructionsToContainerView(containerView, constraints: constraints)
        
        // Add a dummy view to center the card between the explanatory view and the bottom layout guide
        let dummyView = addDummyViewToContainerView(containerView, topItem: swipeInstructionsView, bottomItem: bottomLayoutGuide, constraints: constraints)
        
        // Create and add the card
        let cardView = addCardViewToView(containerView)
        
        // Define the vertical positioning of the card
        // These constraints will be removed when the card animates off screen
        cardViewVerticalConstraints =
            [
                NSLayoutConstraint(item: cardView, attribute: .CenterY, relatedBy: .Equal, toItem: dummyView, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: cardView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: swipeInstructionsView, attribute: .Bottom, multiplier: 1.0, constant: HelloGoodbyeVerticalMargin)
        ]
        constraints.addObjectsFromArray(cardViewVerticalConstraints as [AnyObject])
        
        // Ensure that the card is centered horizontally within the container view, and doesn't exceed its width
        constraints.addObjectsFromArray(
            [
                NSLayoutConstraint(item: cardView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: cardView, attribute: .Left, relatedBy: .GreaterThanOrEqual, toItem: containerView, attribute: .Left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: cardView, attribute: .Right, relatedBy: .LessThanOrEqual, toItem: containerView, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])
        
        // When the matches run out, we'll show this message
        allMatchesViewedExplanatoryView = addAllMatchesViewExplanatoryViewToContainerView(containerView, constraints: constraints)
        
        containerView.addConstraints(constraints as [AnyObject])
    }
    
    private func addDummyViewToContainerView(containerView: UIView!, topItem: AnyObject!, bottomItem: AnyObject!, constraints: NSMutableArray!) -> UIView! {
        let dummyView = UIView()
        dummyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addSubview(dummyView)
        
        // The horizontal layout of the dummy view does not matter, but for completeness, we give it a width of 0 and center it horizontally.
        constraints.addObjectsFromArray(
            [
                NSLayoutConstraint(item: dummyView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .Top, relatedBy: .Equal, toItem: topItem, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: dummyView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomItem, attribute: .Top, multiplier: 1.0, constant: 0.0)
            ])
        
        return dummyView
    }
    
    private func addCardViewToView(containerView: UIView!) -> CardView {
        let cardView = CardView()
        cardView.updateWithPerson(currentMatch())
        cardView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.cardView = cardView
        containerView.addSubview(cardView)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeUp:")
        swipeUpRecognizer.direction = .Up
        cardView.addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeDown:")
        swipeDownRecognizer.direction = .Down
        cardView.addGestureRecognizer(swipeDownRecognizer)
        
        let helloAction = UIAccessibilityCustomAction(name: NSLocalizedString("Say hello", comment: "Accessibility action to say hello"), target: self, selector: "sayHello")
        let goodbyeAction = UIAccessibilityCustomAction(name: NSLocalizedString("Say goodbye", comment: "Accessibility action to say goodbye"), target: self, selector: "sayGoodbye")
        for element in cardView.accessibilityElements as! [UIView] {
            element.accessibilityCustomActions = [helloAction, goodbyeAction]
        }
        
        return cardView
    }
    
    private func addOverlayViewToContainerView(containerView: UIView!) ->UIView! {
        let overlayView = UIView()
        overlayView.backgroundColor = StyleUtilities.overlayColor()
        overlayView.layer.cornerRadius = StyleUtilities.overlayCornerRadius
        overlayView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addSubview(overlayView)
        return overlayView
    }
    
    let UILayoutPriorityRequired:Float = 1000
    private func addSwipeInstructionsToContainerView(containerView: UIView!, constraints: NSMutableArray!) -> UIView! {
        let overlayView = addOverlayViewToContainerView(containerView)
        
        let swipeInstructionsLabel = StyleUtilities.standardLabel
        swipeInstructionsLabel.font = StyleUtilities.largeFont
        overlayView.addSubview(swipeInstructionsLabel)
        swipeInstructionsLabel.text = NSLocalizedString("Swipe ↑ to say \"Hello!\"\nSwipe ↓ to say \"Goodbye...\"", comment: "Instructions for the Matches page")
        swipeInstructionsLabel.accessibilityLabel = NSLocalizedString("Swipe up to say \"Hello!\"\nSwipe down to say \"Goodbye\"", comment: "Accessibility instructions for the Matches page")
        
        let overlayMargin = StyleUtilities.overlayMargin
        let topMarginConstraint = NSLayoutConstraint(item: overlayView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: overlayMargin)
        topMarginConstraint.priority = UILayoutPriorityRequired - 1
        constraints.addObject(topMarginConstraint)
        // Position the label inside the overlay view
        constraints.addObject(NSLayoutConstraint(item: swipeInstructionsLabel, attribute: .Top, relatedBy: .Equal, toItem: overlayView, attribute: .Top, multiplier: 1.0, constant: HelloGoodbyeVerticalMargin))
        constraints.addObject(NSLayoutConstraint(item: swipeInstructionsLabel, attribute: .CenterX, relatedBy: .Equal, toItem: overlayView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: overlayView, attribute: .Bottom, relatedBy: .Equal, toItem: swipeInstructionsLabel, attribute: .Bottom, multiplier: 1.0, constant: HelloGoodbyeVerticalMargin))
        
        // Center the overlay view horizontally
        constraints.addObject(NSLayoutConstraint(item: overlayView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1.0, constant: overlayMargin))
        constraints.addObject(NSLayoutConstraint(item: overlayView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1.0, constant: -overlayMargin))
        return overlayView
    }
    
    
    private func addAllMatchesViewExplanatoryViewToContainerView(containerView: UIView!, constraints: NSMutableArray!) -> UIView! {
        let overlayView = addOverlayViewToContainerView(containerView)
        
        // Start out hidden
        // This view will become visible once all matches have been viewed
        overlayView.alpha = 0.0
        
        let label = StyleUtilities.standardLabel
        label.font = StyleUtilities.largeFont
        label.text = NSLocalizedString("Stay tuned for more matches!", comment: "Shown when all matches have been viewed")
        overlayView.addSubview(label)
        
        // Center the overlay view
        constraints.addObject(NSLayoutConstraint(item: overlayView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        constraints.addObject(NSLayoutConstraint(item: overlayView, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // Position the label in the overlay view
        constraints.addObject(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: overlayView, attribute: .Top, multiplier: 1.0, constant: StyleUtilities.contentVerticalMargin))
        constraints.addObject(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: overlayView, attribute: .Bottom, multiplier: 1.0, constant: -StyleUtilities.contentVerticalMargin))
        constraints.addObject(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: overlayView, attribute: .Leading, multiplier: 1.0, constant: StyleUtilities.contentHorizontalMargin))
        constraints.addObject(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: overlayView, attribute: .Trailing, multiplier: 1.0, constant: -StyleUtilities.contentHorizontalMargin))
        return overlayView
    }
    
    private func currentMatch() -> Person? {
        var currentMatch: Person? = nil
        if currentMatchIndex < matches.count {
            currentMatch = (matches[currentMatchIndex] as Person)
        }
        return currentMatch
    }
    
    private func zoomCardIntoView() {
        cardView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(ZoomAnimationDuration) {
            self.cardView.transform = CGAffineTransformIdentity
        }
    }
    
    private func animateCardOffScreenToTop(toTop: Bool, completion: (()->Void)?) {
        var offScreenConstraint: NSLayoutConstraint? = nil
        if toTop {
            offScreenConstraint = NSLayoutConstraint(item: cardView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        } else {
            offScreenConstraint = NSLayoutConstraint(item: cardView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        }
        
        view.layoutIfNeeded()
        UIView.animateWithDuration(SwipeAnimationDuration, animations: {
            // Slide the card off screen
            self.view.removeConstraints(self.cardViewVerticalConstraints as [AnyObject])
            self.view.addConstraint(offScreenConstraint!)
            self.view.layoutIfNeeded()
            }) {finished in
                // Bring the card back into view
                self.view.removeConstraint(offScreenConstraint!)
                self.view.addConstraints(self.cardViewVerticalConstraints as [AnyObject])
                completion?()
        }
    }
    
    private func fadeCardIntoView() {
        cardView.alpha = 0.0
        UIView.animateWithDuration(FadeAnimationDuration) {
            self.cardView.alpha = 1.0
        }
    }
    
    private func animateCardsForHello(forHello: Bool) {
        animateCardOffScreenToTop(forHello) {
            self.currentMatchIndex++
            if let nextMatch = self.currentMatch() {
                // Show the next match's profile in the card
                self.cardView.updateWithPerson(nextMatch)
                
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
                self.cardView.hidden = true
                
                // Fade in the "Stay tuned for more matches" blurb
                UIView.animateWithDuration(FadeAnimationDuration) {
                    self.swipeInstructionsView.alpha = 0.0
                    self.allMatchesViewedExplanatoryView.alpha = 1.0
                }
            }
            
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    private func sayHello() -> Bool {
        animateCardsForHello(true)
        return true
    }
    
    private func sayGoodbye() ->Bool {
        animateCardsForHello(false)
        return true
    }
    
    let UIGestureRecognizerStateRecognized = UIGestureRecognizerState.Ended
    func handleSwipeUp(gestureRecognizer: UISwipeGestureRecognizer!) {
        if gestureRecognizer.state == UIGestureRecognizerStateRecognized {
            sayHello()
        }
    }
    
    func handleSwipeDown(gestureRecognizer: UISwipeGestureRecognizer!) {
        if gestureRecognizer.state == UIGestureRecognizerStateRecognized {
            sayGoodbye()
        }
    }
    
}