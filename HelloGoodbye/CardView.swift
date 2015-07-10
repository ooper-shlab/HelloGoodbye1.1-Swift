//
//  CardView.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/14.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  The profile card view.

 */

import UIKit

private let CardPhotoWidth:CGFloat = 80.0
private let CardBorderWidth:CGFloat = 5.0
private let CardHorizontalPadding:CGFloat = 20.0
private let CardVerticalPadding:CGFloat = 20.0
private let CardInterItemHorizontalSpacing:CGFloat = 30.0
private let CardInterItemVerticalSpacing:CGFloat = 10.0
private let CardTitleValueSpacing:CGFloat = 0.0

@objc(AAPLCardView)
class CardView: UIView {
    
    private var backgroundView:UIView!
    private var photo:UIImageView!
    private var ageTitleLabel:UILabel!
    private var ageValueLabel:UILabel!
    private var hobbiesTitleLabel:UILabel!
    private var hobbiesValueLabel:UILabel!
    private var elevatorPitchTitleLabel:UILabel!
    private var elevatorPitchValueLabel:UILabel!
    private var photoAspectRatioConstraint:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = StyleUtilities.cardBorderColor()
        
        backgroundView = UIView()
        backgroundView.backgroundColor = StyleUtilities.cardBackgroundColor()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        addProfileViews()
        addAllConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addProfileViews() {
        photo = UIImageView()
        photo.isAccessibilityElement = true
        photo.accessibilityLabel =  NSLocalizedString("Profile photo", comment: "Accessibility label for profile photo")
        photo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photo)
        
        ageTitleLabel = StyleUtilities.standardLabel
        ageTitleLabel.text = NSLocalizedString("Age", comment: "Age of the user")
        addSubview(ageTitleLabel)
        ageValueLabel = StyleUtilities.detailLabel
        addSubview(ageValueLabel)
        
        hobbiesTitleLabel = StyleUtilities.standardLabel
        hobbiesTitleLabel.text = NSLocalizedString("Hobbies", comment: "The user's hobbies")
        addSubview(hobbiesTitleLabel)
        
        hobbiesValueLabel = StyleUtilities.detailLabel
        addSubview(hobbiesValueLabel)
        
        elevatorPitchTitleLabel = StyleUtilities.standardLabel
        elevatorPitchTitleLabel.text = NSLocalizedString("Elevator Pitch", comment: "The user's elevator pitch for finding a partner")
        addSubview(elevatorPitchTitleLabel)
        
        elevatorPitchValueLabel = StyleUtilities.detailLabel
        addSubview(elevatorPitchValueLabel)
        
        accessibilityElements = [photo, ageTitleLabel, ageValueLabel, hobbiesTitleLabel, hobbiesValueLabel,
            elevatorPitchTitleLabel, elevatorPitchValueLabel]
    }
    
    private func addAllConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        // Fill the card with the background view (leaving a border around it)
        constraints +=
            [
                NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: CardBorderWidth),
                NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: CardBorderWidth),
                NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: backgroundView, attribute: .Trailing, multiplier: 1.0, constant: CardBorderWidth),
                NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: backgroundView, attribute: .Bottom, multiplier: 1.0, constant: CardBorderWidth)
            ]
        
        // Position the photo
        // The constant for the aspect ratio constraint will be updated once a photo is set
        photoAspectRatioConstraint = NSLayoutConstraint(item: photo, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 0.0)
        constraints +=
            [
                NSLayoutConstraint(item: photo, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: CardHorizontalPadding),
                NSLayoutConstraint(item: photo, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: CardVerticalPadding),
                NSLayoutConstraint(item: photo, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: CardPhotoWidth),
                NSLayoutConstraint(item: photo, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -CardVerticalPadding),
                photoAspectRatioConstraint
            ]
        
        // Position the age to the right of the photo, with some spacing
        constraints +=
            [
                NSLayoutConstraint(item: ageTitleLabel, attribute: .Leading, relatedBy: .Equal, toItem: photo, attribute: .Trailing, multiplier: 1.0, constant: CardInterItemHorizontalSpacing),
                NSLayoutConstraint(item: ageTitleLabel, attribute: .Top, relatedBy: .Equal, toItem: photo, attribute: .Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: ageValueLabel, attribute: .Top, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .Bottom, multiplier: 1.0, constant: CardTitleValueSpacing),
                NSLayoutConstraint(item: ageValueLabel, attribute: .Leading, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0)
            ]
        
        // Position the hobbies to the right of the age
        constraints +=
            [
                NSLayoutConstraint(item: hobbiesTitleLabel, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: ageTitleLabel, attribute: .Trailing, multiplier: 1.0, constant: CardInterItemHorizontalSpacing),
                NSLayoutConstraint(item: hobbiesTitleLabel, attribute: .FirstBaseline, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .FirstBaseline, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: hobbiesValueLabel, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: ageValueLabel, attribute: .Trailing, multiplier: 1.0, constant: CardInterItemHorizontalSpacing),
                NSLayoutConstraint(item: hobbiesValueLabel, attribute: .Leading, relatedBy: .Equal, toItem: hobbiesTitleLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: hobbiesValueLabel, attribute: .FirstBaseline, relatedBy: .Equal, toItem: ageValueLabel, attribute: .FirstBaseline, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: hobbiesTitleLabel, attribute: .Trailing, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -CardHorizontalPadding),
                NSLayoutConstraint(item: hobbiesValueLabel, attribute: .Trailing, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -CardHorizontalPadding)
            ]
        
        // Position the elevator pitch below the age and the hobbies
        constraints +=
            [
                NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .Leading, relatedBy: .Equal, toItem: ageTitleLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: ageValueLabel, attribute: .Bottom, multiplier: 1.0, constant: CardInterItemVerticalSpacing),
                NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: hobbiesValueLabel, attribute: .Bottom, multiplier: 1.0, constant: CardInterItemVerticalSpacing),
                NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -CardHorizontalPadding),
                NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .Top, relatedBy: .Equal, toItem: elevatorPitchTitleLabel, attribute: .Bottom, multiplier: 1.0, constant: CardTitleValueSpacing),
                NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .Leading, relatedBy: .Equal, toItem: elevatorPitchTitleLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -CardHorizontalPadding),
                NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -CardVerticalPadding)
            ]
        
        addConstraints(constraints)
    }
    
    func updateWithPerson(person: Person!) {
        photo.image = person.photo
        updatePhotoConstraint()
        ageValueLabel.text = NSNumberFormatter.localizedStringFromNumber(person.age, numberStyle: .DecimalStyle)
        hobbiesValueLabel.text = person.hobbies
        elevatorPitchValueLabel.text = person.elevatorPitch
    }
    
    private func updatePhotoConstraint() {
        photoAspectRatioConstraint.constant = (photo.image!.size.height / photo.image!.size.width) * CardPhotoWidth
    }
    
}