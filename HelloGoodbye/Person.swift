//
//  File.swift
//  HelloGoodbye
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/08/12.
//
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  A model class that represents a user in the application.

 */

import UIKit
private let PersonPhotoKey = "photo"
private let PersonAgeKey = "age"
private let PersonHobbiesKey = "hobbies"
private let PersonElevatorPitchKey = "elevatorPitch"

@objc(AAPLPerson)
class Person: NSObject {

    var photo: UIImage
    var age: Int
    var hobbies: String
    var elevatorPitch: String

    convenience init(dictionary personDictionary: [String: Any]) {

        self.init(photo: personDictionary[PersonPhotoKey] as! String,
                  age:personDictionary[PersonAgeKey] as! Int,
                  hobbies: personDictionary[PersonHobbiesKey] as! String,
                  elevatorPitch: personDictionary[PersonElevatorPitchKey] as! String)
    }
    init(photo: String, age: Int, hobbies: String, elevatorPitch: String) {
        
        self.photo = UIImage(named: photo)!
        self.age = age
        self.hobbies = hobbies
        self.elevatorPitch = elevatorPitch
    }

}
