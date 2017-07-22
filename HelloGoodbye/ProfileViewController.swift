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
private let CardRevealAnimationDuration: TimeInterval = 0.3

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
        person = Person(
        photo: "girl",
        age: 37,
        hobbies: "Music, swing dance, wine",
        elevatorPitch: "I can keep a steady beat.")
    }
    
    //MARK: - Views and Constraints
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = view!
        var constraints: [NSLayoutConstraint] = []
        
        let overlayView = addOverlayView(to: containerView, constraints: &constraints)
        let ageControls = addAgeControls(to: overlayView, constraints: &constraints)
        hobbiesField = addTextField(name: NSLocalizedString("Hobbies", comment: "The user's hobbies"),
            text: person.hobbies, to: overlayView, previousRowItems: ageControls, constraints: &constraints)
        elevatorPitchField = addTextField(name: NSLocalizedString("Elevator Pitch", comment: "The user's elevator pitch for finding a partner"), text: person.elevatorPitch, to: overlayView, previousRowItems: [hobbiesField], constraints: &constraints)
        
        addCardAndPreviewTab(&constraints)
        
        containerView.addConstraints(constraints)
    }
    
    private func addOverlayView(to containerView: UIView, constraints: inout [NSLayoutConstraint]) -> UIView {
        let overlayView = UIView()
        overlayView.backgroundColor = StyleUtilities.overlayColor
        overlayView.layer.cornerRadius = StyleUtilities.overlayCornerRadius
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(overlayView)
        
        // Cover the view controller with the overlay, leaving a margin on all sides
        let margin = StyleUtilities.overlayMargin
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: margin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -margin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1.0, constant: margin))
        constraints.append(NSLayoutConstraint(item: overlayView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1.0, constant: -margin))
        return overlayView
    }
    
    private func updateAgeValueLabel(from ageSlider: AgeSlider) {
        ageValueLabel.text = NumberFormatter.localizedString(from: ageSlider.value as NSNumber, number: .decimal)
    }
    
    private func addAgeValueLabel(to overlayView: UIView) -> UILabel {
        let ageValueLabel = StyleUtilities.standardLabel()
        ageValueLabel.isAccessibilityElement = false
        overlayView.addSubview(ageValueLabel)
        return ageValueLabel
    }
    
    private func addAgeControls(to overlayView: UIView, constraints: inout [NSLayoutConstraint]) -> [UIView] {
        let ageTitleLabel = StyleUtilities.standardLabel()
        ageTitleLabel.text = NSLocalizedString("Your age", comment: "The user's age")
        overlayView.addSubview(ageTitleLabel)
        
        let ageSlider = AgeSlider()
        ageSlider.value = Float(person.age)
        ageSlider.addTarget(self, action: #selector(ProfileViewController.didUpdateAge(_:)), for: .valueChanged)
        ageSlider.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(ageSlider)
        
        // Display the current age next to the slider
        ageValueLabel = addAgeValueLabel(to: overlayView)
        updateAgeValueLabel(from: ageSlider)
        
        // Position the age title and value side by side, within the overlay view
        constraints.append(NSLayoutConstraint(item: ageTitleLabel, attribute: .top, relatedBy: .equal, toItem: overlayView, attribute: .top, multiplier: 1.0, constant: StyleUtilities.contentVerticalMargin))
        constraints.append(NSLayoutConstraint(item: ageTitleLabel, attribute: .leading, relatedBy: .equal, toItem: overlayView, attribute: .leading, multiplier: 1.0, constant: StyleUtilities.contentHorizontalMargin))
        constraints.append(NSLayoutConstraint(item: ageSlider, attribute: .leading, relatedBy: .equal, toItem: ageTitleLabel, attribute: .trailing, multiplier: 1.0, constant: LabelControlMinimumSpacing))
        constraints.append(NSLayoutConstraint(item: ageSlider, attribute: .centerY, relatedBy: .equal, toItem: ageTitleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .leading, relatedBy: .equal, toItem: ageSlider, attribute: .trailing, multiplier: 1.0, constant: LabelControlMinimumSpacing))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: ageTitleLabel, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: 1.0, constant: -StyleUtilities.contentHorizontalMargin))
        
        return [ageTitleLabel, ageSlider, ageValueLabel]
    }
    
    private func addTextField(name: String, text: String, to overlayView: UIView!, previousRowItems: [UIView], constraints: inout [NSLayoutConstraint]) -> UITextField {
        let titleLabel = StyleUtilities.standardLabel()
        titleLabel.text = name
        overlayView.addSubview(titleLabel)
        
        let valueFeild = UITextField()
        valueFeild.delegate = self
        valueFeild.font = StyleUtilities.standardFont
        valueFeild.textColor = StyleUtilities.detailOnOverlayColor
        valueFeild.text = text
        valueFeild.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Type here...", comment: "Placeholder for profile text fields") , attributes: [NSAttributedStringKey.foregroundColor: StyleUtilities.detailOnOverlayPlaceholderColor])
        valueFeild.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(valueFeild)
        
        // Ensure sufficient spacing from the row above this one
        for previousRowItem in previousRowItems {
            constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: previousRowItem, attribute: .bottom, multiplier: 1.0, constant: MinimumVerticalSpacingBetweenRows))
        }
        
        // Place the title directly above the value
        constraints.append(NSLayoutConstraint(item: valueFeild, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        // Position the title and value within the overlay view
        constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: overlayView, attribute: .leading, multiplier: 1.0, constant: StyleUtilities.contentHorizontalMargin))
        constraints.append(NSLayoutConstraint(item: valueFeild, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: valueFeild, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: 1.0, constant: -StyleUtilities.contentHorizontalMargin))
        
        return valueFeild
    }
    
    private func previewTabBackgroundImage() -> UIImage {
        // The preview tab should be flat on the bottom, and have rounded corners on top.
        UIGraphicsBeginImageContextWithOptions(CGSize(width: PreviewTabMinimumWidth, height: PreviewTabHeight), false, UIScreen.main.scale)
        let roundedTopCornersRect = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: PreviewTabMinimumWidth, height: PreviewTabHeight), byRoundingCorners:([.topLeft, .topRight]), cornerRadii:CGSize(width: PreviewTabCornerRadius, height: PreviewTabCornerRadius))
        StyleUtilities.foregroundColor.set()
        roundedTopCornersRect.fill()
        var previewTabBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()!
        previewTabBackgroundImage = previewTabBackgroundImage.resizableImage(withCapInsets: UIEdgeInsetsMake(0.0, PreviewTabCornerRadius, 0.0, PreviewTabCornerRadius))
        UIGraphicsEndImageContext()
        return previewTabBackgroundImage
    }
    
    private func addPreviewTab() -> UIImageView {
        let previewTabBackgroundImage = self.previewTabBackgroundImage()
        let previewTab = UIImageView(image: previewTabBackgroundImage)
        previewTab.isUserInteractionEnabled = true
        view.addSubview(previewTab)
        
        let revealGestureRecognizer = UIPanGestureRecognizer(target:self, action:#selector(ProfileViewController.didSlidePreviewTab(_:)))
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
        cardView.update(person: person)
        self.cardView = cardView
        view.addSubview(cardView)
        return cardView
    }
    
    func addCardAndPreviewTab(_ constraints: inout [NSLayoutConstraint]) {
        previewTab = addPreviewTab()
        previewTab.translatesAutoresizingMaskIntoConstraints = false
        
        let previewLabel = addPreviewLabel()
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cardView = addCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Pin the tab to the bottom center of the screen
        cardRevealConstraint = NSLayoutConstraint(item: previewTab, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        constraints.append(cardRevealConstraint)
        constraints.append(NSLayoutConstraint(item: previewTab, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        // Center the preview label within the tab
        constraints.append(NSLayoutConstraint(item: previewLabel, attribute: .leading, relatedBy: .equal, toItem: previewTab, attribute: .leading, multiplier: 1.0, constant: PreviewTabHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: previewLabel, attribute: .trailing, relatedBy: .equal, toItem: previewTab, attribute: .trailing, multiplier: 1.0, constant: -PreviewTabHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: previewLabel, attribute: .centerY, relatedBy: .equal, toItem: previewTab, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // Pin the top of the card to the bottom of the tab
        constraints.append(NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .equal, toItem: previewTab, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal, toItem: previewTab, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        // Ensure that the card fits within the view
        constraints.append(NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
    
    //MARK: - Responding to Actions
    
    @objc func didUpdateAge(_ ageSlider: AgeSlider) {
        // Turn the value into a valid age
        ageSlider.value = round(ageSlider.value)
        
        // Display the updated age next to the slider
        updateAgeValueLabel(from: ageSlider)
        
        // Update the model
        person.age = Int(ageSlider.value)
        
        // Update the card view with the new data
        cardView.update(person: person)
    }
    
    private var isCardRevealed: Bool {
        return cardRevealConstraint.constant < 0.0
    }
    
    private var cardHeight: CGFloat {
        return cardView.frame.height
    }
    
    private func revealCard() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: CardRevealAnimationDuration, animations: {
            self.cardRevealConstraint.constant = -self.cardHeight
            self.view.layoutIfNeeded()
            }) {finished in
                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    private func dismissCard() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: CardRevealAnimationDuration, animations: {
            self.cardRevealConstraint.constant = 0.0
            self.view.layoutIfNeeded()
            }) {finished in
                UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    @objc func didSlidePreviewTab(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            cardWasRevealedBeforePan = isCardRevealed
            
        case .changed:
            let cardHeight = self.cardHeight
            var cardRevealConstant = gestureRecognizer.translation(in: view).y
            if cardWasRevealedBeforePan {
                cardRevealConstant += -cardHeight
            }
            // Never let the card tab move off screen
            cardRevealConstant = min(0.0, cardRevealConstant)
            // Never let the card have a gap below it
            cardRevealConstant = max(-cardHeight, cardRevealConstant)
            cardRevealConstraint.constant = cardRevealConstant
        case .ended:
            if cardRevealConstraint.constant > -0.5 * self.cardHeight {
                // Card was closer to the bottom of the screen
                dismissCard()
            } else {
                revealCard()
            }
        case .cancelled:
            if cardWasRevealedBeforePan {
                revealCard()
            } else {
                dismissCard()
            }
        default:
            break
        }
    }
    
    @objc func doneButtonPressed(_ sender: Any) {
        // End editing on whichever text field is first responder
        hobbiesField.resignFirstResponder()
        elevatorPitchField.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Add a Done button so that the user can dismiss the keyboard easily
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ProfileViewController.doneButtonPressed(_:)))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Remove the Done button
        navigationItem.rightBarButtonItem = nil
        
        // Update the model
        if textField === hobbiesField {
            person.hobbies = textField.text ?? ""
        } else if textField === elevatorPitchField {
            person.elevatorPitch = textField.text ?? ""
        }
        
        // Update the card view with the new data
        cardView.update(person: person)
    }
    
    //MARK: - AAPLPreviewLabelDelegate
    
    func didActivate(_ previewLabel: PreviewLabel) {
        if isCardRevealed {
            dismissCard()
        } else {
            revealCard()
        }
    }
    
}
