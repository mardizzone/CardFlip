//
//  File.swift
//  CFB
//
//  Created by Michael Ardizzone on 1/30/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation


func modelToDictionary(input: [Person]) -> [String : [String : String]] {
    var dictToReturn = [String : [String : String] ]()
    
    for item in input {
        dictToReturn[item.name] = [ "personality" : item.personality, "interests" : item.interests, "datingPrefs" : item.dating_preferences ]
    }
    
    return dictToReturn
}

//func stringToUIView(input: String) -> BackCardView {
//    var interestsText = 
//    
//}

