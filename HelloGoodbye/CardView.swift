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
        backgroundColor = StyleUtilities.cardBorderColor
        
        backgroundView = UIView()
        backgroundView.backgroundColor = StyleUtilities.cardBackgroundColor
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
        
        ageTitleLabel = StyleUtilities.standardLabel()
        ageTitleLabel.text = NSLocalizedString("Age", comment: "Age of the user")
        addSubview(ageTitleLabel)
        ageValueLabel = StyleUtilities.detailLabel()
        addSubview(ageValueLabel)
        
        hobbiesTitleLabel = StyleUtilities.standardLabel()
        hobbiesTitleLabel.text = NSLocalizedString("Hobbies", comment: "The user's hobbies")
        addSubview(hobbiesTitleLabel)
        
        hobbiesValueLabel = StyleUtilities.detailLabel()
        addSubview(hobbiesValueLabel)
        
        elevatorPitchTitleLabel = StyleUtilities.standardLabel()
        elevatorPitchTitleLabel.text = NSLocalizedString("Elevator Pitch", comment: "The user's elevator pitch for finding a partner")
        addSubview(elevatorPitchTitleLabel)
        
        elevatorPitchValueLabel = StyleUtilities.detailLabel()
        addSubview(elevatorPitchValueLabel)
        
        accessibilityElements = [photo, ageTitleLabel, ageValueLabel, hobbiesTitleLabel, hobbiesValueLabel,
            elevatorPitchTitleLabel, elevatorPitchValueLabel]
    }
    
    private func addAllConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        // Fill the card with the background view (leaving a border around it)
        constraints.append(NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: CardBorderWidth))
        constraints.append(NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: CardBorderWidth))
        constraints.append(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1.0, constant: CardBorderWidth))
        constraints.append(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: CardBorderWidth))
   
        // Position the photo
        // The constant for the aspect ratio constraint will be updated once a photo is set
        photoAspectRatioConstraint = NSLayoutConstraint(item: photo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
        constraints.append(NSLayoutConstraint(item: photo, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: CardHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: photo, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: CardVerticalPadding))
        constraints.append(NSLayoutConstraint(item: photo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: CardPhotoWidth))
        constraints.append(NSLayoutConstraint(item: photo, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -CardVerticalPadding))
        constraints.append(photoAspectRatioConstraint)
        
        // Position the age to the right of the photo, with some spacing
        constraints.append(NSLayoutConstraint(item: ageTitleLabel, attribute: .leading, relatedBy: .equal, toItem: photo, attribute: .trailing, multiplier: 1.0, constant: CardInterItemHorizontalSpacing))
        constraints.append(NSLayoutConstraint(item: ageTitleLabel, attribute: .top, relatedBy: .equal, toItem: photo, attribute: .top, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .top, relatedBy: .equal, toItem: ageTitleLabel, attribute: .bottom, multiplier: 1.0, constant: CardTitleValueSpacing))
        constraints.append(NSLayoutConstraint(item: ageValueLabel, attribute: .leading, relatedBy: .equal, toItem: ageTitleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0))
        
        // Position the hobbies to the right of the age
        constraints.append(NSLayoutConstraint(item: hobbiesTitleLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: ageTitleLabel, attribute: .trailing, multiplier: 1.0, constant: CardInterItemHorizontalSpacing))
        constraints.append(NSLayoutConstraint(item: hobbiesTitleLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: ageTitleLabel, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: hobbiesValueLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: ageValueLabel, attribute: .trailing, multiplier: 1.0, constant: CardInterItemHorizontalSpacing))
        constraints.append(NSLayoutConstraint(item: hobbiesValueLabel, attribute: .leading, relatedBy: .equal, toItem: hobbiesTitleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: hobbiesValueLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: ageValueLabel, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: hobbiesTitleLabel, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -CardHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: hobbiesValueLabel, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -CardHorizontalPadding))
        
        // Position the elevator pitch below the age and the hobbies
        constraints.append(NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .leading, relatedBy: .equal, toItem: ageTitleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: ageValueLabel, attribute: .bottom, multiplier: 1.0, constant: CardInterItemVerticalSpacing))
        constraints.append(NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: hobbiesValueLabel, attribute: .bottom, multiplier: 1.0, constant: CardInterItemVerticalSpacing))
        constraints.append(NSLayoutConstraint(item: elevatorPitchTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -CardHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .top, relatedBy: .equal, toItem: elevatorPitchTitleLabel, attribute: .bottom, multiplier: 1.0, constant: CardTitleValueSpacing))
        constraints.append(NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .leading, relatedBy: .equal, toItem: elevatorPitchTitleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0))
        constraints.append(NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -CardHorizontalPadding))
        constraints.append(NSLayoutConstraint(item: elevatorPitchValueLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -CardVerticalPadding))
        
        addConstraints(constraints)
    }
    
    func update(person: Person!) {
        photo.image = person.photo
        updatePhotoConstraint()
        ageValueLabel.text = NumberFormatter.localizedString(from: person.age as NSNumber, number: .decimal)
        hobbiesValueLabel.text = person.hobbies
        elevatorPitchValueLabel.text = person.elevatorPitch
    }
    
    private func updatePhotoConstraint() {
        photoAspectRatioConstraint.constant = (photo.image!.size.height / photo.image!.size.width) * CardPhotoWidth
    }
    
}
