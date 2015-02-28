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

    var photo: UIImage!
    var age: Int = 0
    var hobbies: String!
    var elevatorPitch: String!

    class func personWithDictionary(personDictionary: NSDictionary)->Person {
        let person = Person()

        person.photo = UIImage(named: personDictionary[PersonPhotoKey] as! String)
        person.age = (personDictionary[PersonAgeKey] as! NSNumber).integerValue
        person.hobbies = personDictionary[PersonHobbiesKey] as! String
        person.elevatorPitch = personDictionary[PersonElevatorPitchKey] as! String
        return person
    }

}