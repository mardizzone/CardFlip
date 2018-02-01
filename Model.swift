//
//  Model.swift
//  CFB
//
//  Created by Michael Ardizzone on 1/28/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation

struct Person: Decodable {
    let id : String
    let name : String
    let position : String
    let profile_image : String
    let personality : String
    let interests : String
    let dating_preferences : String
}

func loadJson(filename fileName: String) -> [Person]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Person].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

func modelToDictionary(input: [Person]) -> [String : [String : String]] {
    var dictToReturn = [String : [String : String] ]()
    
    for item in input {
        dictToReturn[item.name] = [ "personality" : item.personality, "interests" : item.interests, "datingPrefs" : item.dating_preferences ]
    }
    
    return dictToReturn
}
