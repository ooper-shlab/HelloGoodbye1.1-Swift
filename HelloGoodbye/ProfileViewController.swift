//
//  AAPLProfileViewController.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/15.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  The profile view controller in the application.  Allows users to view, edit, and preview their profile.

 */

import UIKit

private let LabelControlMinimumSpacing: CGFloat = 20.0
private let MinimumVerticalSpacingBetweenRows: CGFloat = 20.0
private let PreviewTabMinimumWidth: CGFloat = 80.0
private let PreviewTabHeight: CGFloat = 30.0
private let PreviewTabCornerRadius: CGFloat = 10.0
private let PreviewTabHorizontalPadding: CGFloat = 30.0
private let CardRevealAnimationDuration: NSTimeInterval = 0.3

@objc(AAPLProfileViewController)
class ProfileViewController: AAPLPhotoBackgroundViewController,
    UITextFieldDelegate, PreviewLabelDelegate
{
    
    private var person: Person!
    private var ageValueLabel: UILabel!
    private var hobbiesField: UITextField!
    private var elevatorPitchField: UITextField!
    private var previewTab: UIImageView!
    private var cardView: CardView!
    private var cardRevealConstraint: NSLayoutConstraint!
    private var cardWasRevealedBeforePan: Bool = false
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("Profile", comment: "Title of the profile page")
        backgroundImage = UIImage(named: "girl-bg")
        
        // Create the model.  If we had a backing service, this model would pull data from the user's account settings.
        person = Person()
        person.photo = UIImage(named: "girl")
        person.age = 37
        person.hobbies = "Music, swing dance, wine"
        person.elevatorPitch = "I can keep a steady beat."
    }
    
    //MARK: - Views and Constraints
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = view
        var constraints: [NSLayoutConstraint] = []
        
        let overlayView = addOverlayViewToView(containerView, constraints: &constraints)
        let ageControls = addAgeControlsToView(overlayView, constraints: &constraints)
        hobbiesField = addTextFieldWithName(NSLocalizedString("Hobbies", comment: "The user's hobbies"),
            text: person.hobbies, toView: overlayView, previousRowItems: ageControls, constraints: &constraints)
        elevatorPitchField = addTextFieldWithName(NSLocalizedString("Elevator Pitch", comment: "The user's elevator pitch for finding a partner"), text: person.elevatorPitch, toView: overlayView, previousRowItems: [hobbiesField], constraints: &constraints)
        
        addCardAndPreviewTab(&constraints)
        
        containerView.addConstraints(constraints)
    }
    
    private func addOverlayViewToView(containerView: UIView!, inout constraints: [NSLayoutConstraint]) -> UIView! {
        let overlayView = UIView()
        overlayView.backgroundColor = StyleUtilities.overlayColor()
        overlayView.layer.cornerRadius = StyleUtilities.overlayCornerRadius
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(overlayView)
        
        // Cover the view controller with the overlay, leaving a margin on all sides
        let margin = StyleUtilities.overlayMargin
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: margin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: -margin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1.0, constant: margin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1.0, constant: -margin))
        return overlayView
    }
    
    private func updateAgeValueLabelFromSlider(ageSlider: AgeSlider) {
        ageValueLabel.text = NSNumberFormatter.localizedStringFromNumber(ageSlider.value, numberStyle: .DecimalStyle)
    }
    
    private func addAgeValueLabelToView(overlayView: UIView!) -> UILabel! {
        let ageValueLabel = StyleUtilities.standardLabel
        ageValueLabel.isAccessibilityElement = false
        overlayView.addSubview(ageValueLabel)
        return ageValueLabel
    }
    
    private func addAgeControlsToView(overlayView: UIView!, inout constraints: [NSLayoutConstraint]) -> NSArray {
        let ageTitleLabel = StyleUtilities.standardLabel
        ageTitleLabel.text = NSLocalizedString("Your age", comment: "The user's age")
        overlayView.addSubview(ageTitleLabel)
        
        let ageSlider = AgeSlider()
        ageSlider.value = Float(person.age)
        ageSlider.addTarget(self, action: "didUpdateAge:", forControlEvents: .ValueChanged)
        ageSlider.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(ageSlider)
        
        // Display the current age next to the slider
        ageValueLabel = addAgeValueLabelToView(overlayView)
        updateAgeValueLabelFromSlider(ageSlider)
        
        // Position the age title and value side by side, within the overlay view
        constraints.append(NSLayoutConstraint(item: ageTitleLabel, attribute: .Top, relatedBy: .Equal, toItem: overlayView, attribute: .Top, multiplier: 1.0, constant: StyleUtilities.contentVerticalMargin))
        constraints.append(NSLayoutConstraint(item: ageTitleLabel, attribute: .Leading, relatedBy: .Equal, toItem: overlayView, attribute: .Leading, multiplier: 1.0, constant: StyleUtilities.contentHorizontalMargin))
        constraints.append(NSLayoutConstraint(item: ageSlider, attribute: .Leading, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .Trailing, multiplier: 1.0, constant: LabelControlMinimumSpacing))
        constraints.append(NSLayoutConstraint(item: ageSlider, attribute: .CenterY, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .Leading, relatedBy: .Equal, toItem: ageSlider, attribute: .Trailing, multiplier: 1.0, constant: LabelControlMinimumSpacing))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .FirstBaseline, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .FirstBaseline, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .Trailing, relatedBy: .Equal, toItem: overlayView, attribute: .Trailing, multiplier: 1.0, constant: -StyleUtilities.contentHorizontalMargin))
        
        return [ageTitleLabel, ageSlider, ageValueLabel]
    }
    
    private func addTextFieldWithName(name: String, text: String, toView overlayView: UIView!, previousRowItems: NSArray, inout constraints: [NSLayoutConstraint]) -> UITextField {
        let titleLabel = StyleUtilities.standardLabel
        titleLabel.text = name
        overlayView.addSubview(titleLabel)
        
        let valueFeild = UITextField()
        valueFeild.delegate = self
        valueFeild.font = StyleUtilities.standardFont
        valueFeild.textColor = StyleUtilities.detailOnOverlayColor()
        valueFeild.text = text
        valueFeild.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Type here...", comment: "Placeholder for profile text fields") , attributes: [NSForegroundColorAttributeName: StyleUtilities.detailOnOverlayPlaceholderColor()])
        valueFeild.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(valueFeild)
        
        // Ensure sufficient spacing from the row above this one
        for previousRowItem in previousRowItems as! [UIView] {
            constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: previousRowItem, attribute: .Bottom, multiplier: 1.0, constant: MinimumVerticalSpacingBetweenRows))
        }
        
        // Place the title directly above the value
        constraints.append(NSLayoutConstraint(item: valueFeild, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        // Position the title and value within the overlay view
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: overlayView, attribute: .Leading, multiplier: 1.0, constant: StyleUtilities.contentHorizontalMargin))
        constraints.append(NSLayoutConstraint(item: valueFeild, attribute: .Leading, relatedBy: .Equal, toItem: titleLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: valueFeild, attribute: .Trailing, relatedBy: .Equal, toItem: overlayView, attribute: .Trailing, multiplier: 1.0, constant: -StyleUtilities.contentHorizontalMargin))
        
        return valueFeild
    }
    
    private func previewTabBackgroundImage() -> UIImage {
        // The preview tab should be flat on the bottom, and have rounded corners on top.
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(PreviewTabMinimumWidth, PreviewTabHeight), false, UIScreen.mainScreen().scale)
        let roundedTopCornersRect = UIBezierPath(roundedRect: CGRectMake(0.0, 0.0, PreviewTabMinimumWidth, PreviewTabHeight), byRoundingCorners:([.TopLeft, .TopRight]), cornerRadii:CGSizeMake(PreviewTabCornerRadius, PreviewTabCornerRadius))
        StyleUtilities.foregroundColor().set()
        roundedTopCornersRect.fill()
        var previewTabBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        previewTabBackgroundImage = previewTabBackgroundImage.resizableImageWithCapInsets(UIEdgeInsetsMake(0.0, PreviewTabCornerRadius, 0.0, PreviewTabCornerRadius))
        UIGraphicsEndImageContext()
        return previewTabBackgroundImage
    }
    
    private func addPreviewTab() -> UIImageView {
        let previewTabBackgroundImage = self.previewTabBackgroundImage()
        let previewTab = UIImageView(image: previewTabBackgroundImage)
        previewTab.userInteractionEnabled = true
        view.addSubview(previewTab)
        
        let revealGestureRecognizer = UIPanGestureRecognizer(target:self, action:"didSlidePreviewTab:")
        previewTab.addGestureRecognizer(revealGestureRecognizer)
        return previewTab
    }
    
    private func addPreviewLabel() -> PreviewLabel {
        let previewLabel = PreviewLabel()
        previewLabel.delegate = self
        view.addSubview(previewLabel)
        return previewLabel
    }
    
    private func addCardView() -> CardView {
        let cardView = CardView()
        cardView.updateWithPerson(person)
        self.cardView = cardView
        view.addSubview(cardView)
        return cardView
    }
    
    func addCardAndPreviewTab(inout constraints: [NSLayoutConstraint]) {
        previewTab = addPreviewTab()
        previewTab.translatesAutoresizingMaskIntoConstraints = false
        
        let previewLabel = addPreviewLabel()
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cardView = addCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Pin the tab to the bottom center of the screen
        cardRevealConstraint = NSLayoutConstraint(item: previewTab, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        constraints.append(cardRevealConstraint)
        constraints.append(NSLayoutConstraint(item: previewTab, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        // Center the preview label within the tab
        constraints.append(NSLayoutConstraint(item: previewLabel, attribute: .Leading, relatedBy: .Equal, toItem: previewTab, attribute: .Leading, multiplier: 1.0, constant: PreviewTabHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: previewLabel, attribute: .Trailing, relatedBy: .Equal, toItem: previewTab, attribute: .Trailing, multiplier: 1.0, constant: -PreviewTabHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: previewLabel, attribute: .CenterY, relatedBy: .Equal, toItem: previewTab, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // Pin the top of the card to the bottom of the tab
        constraints.append(NSLayoutConstraint(item: cardView, attribute: .Top, relatedBy: .Equal, toItem: previewTab, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: cardView, attribute: .CenterX, relatedBy: .Equal, toItem: previewTab, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        // Ensure that the card fits within the view
        constraints.append(NSLayoutConstraint(item: cardView, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0))
    }
    
    //MARK: - Responding to Actions
    
    func didUpdateAge(ageSlider: AgeSlider) {
        // Turn the value into a valid age
        ageSlider.value = round(ageSlider.value)
        
        // Display the updated age next to the slider
        updateAgeValueLabelFromSlider(ageSlider)
        
        // Update the model
        person.age = Int(ageSlider.value)
        
        // Update the card view with the new data
        cardView.updateWithPerson(person)
    }
    
    private var isCardRevealed: Bool {
        return cardRevealConstraint.constant < 0.0
    }
    
    private var cardHeight: CGFloat {
        return CGRectGetHeight(cardView.frame)
    }
    
    private func revealCard() {
        view.layoutIfNeeded()
        UIView.animateWithDuration(CardRevealAnimationDuration, animations: {
            self.cardRevealConstraint.constant = -self.cardHeight
            self.view.layoutIfNeeded()
            }) {finished in
                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    private func dismissCard() {
        view.layoutIfNeeded()
        UIView.animateWithDuration(CardRevealAnimationDuration, animations: {
            self.cardRevealConstraint.constant = 0.0
            self.view.layoutIfNeeded()
            }) {finished in
                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    func didSlidePreviewTab(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            cardWasRevealedBeforePan = isCardRevealed
            
        case .Changed:
            let cardHeight = self.cardHeight
            var cardRevealConstant = gestureRecognizer.translationInView(view).y
            if cardWasRevealedBeforePan {
                cardRevealConstant += -cardHeight
            }
            // Never let the card tab move off screen
            cardRevealConstant = min(0.0, cardRevealConstant)
            // Never let the card have a gap below it
            cardRevealConstant = max(-cardHeight, cardRevealConstant)
            cardRevealConstraint.constant = cardRevealConstant
        case .Ended:
            if cardRevealConstraint.constant > -0.5 * self.cardHeight {
                // Card was closer to the bottom of the screen
                dismissCard()
            } else {
                revealCard()
            }
        case .Cancelled:
            if cardWasRevealedBeforePan {
                revealCard()
            } else {
                dismissCard()
            }
        default:
            break
        }
    }
    
    func doneButtonPressed(sender: AnyObject!) {
        // End editing on whichever text field is first responder
        hobbiesField.resignFirstResponder()
        elevatorPitchField.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Add a Done button so that the user can dismiss the keyboard easily
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPressed:")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Remove the Done button
        navigationItem.rightBarButtonItem = nil
        
        // Update the model
        if textField === hobbiesField {
            person.hobbies = textField.text
        } else if textField === elevatorPitchField {
            person.elevatorPitch = textField.text
        }
        
        // Update the card view with the new data
        cardView.updateWithPerson(person)
    }
    
    //MARK: - AAPLPreviewLabelDelegate
    
    func didActivatePreviewLabel(previewLabel: PreviewLabel!) {
        if isCardRevealed {
            dismissCard()
        } else {
            revealCard()
        }
    }
    
}