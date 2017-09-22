//
//  UserData.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation

class UserData{
    private var _uid: String!
    private var _name: String!
    private var _email: String!
    private var _major: [String]!
    private var _bio: String!
    private var _ideas: [IdeaData]!
    
    //For creating a user upon sign in
    init(userUID: String, firstName: String, lastName: String, email: String, major: [String], bio: String){
        self._uid = userUID
        self._name = firstName + " " + lastName
        self._email = email
        self._major = major
        self._bio = bio
    }
    
    //For user list
    init(userUID: String, name: String, major: [String]){
        self._uid = userUID
        self._name = name
        self._major = major
    }
    
    //For user profile
    init(userUID: String, name: String, email: String, major: [String], bio: String, ideas: [IdeaData]){
        self._uid = userUID
        self._name = name
        self._email = email
        self._major = major
        self._ideas = ideas
        self._bio = bio
    }
    
    var userUID: String{
        return _uid
    }
    
    var name: String{
        get{
            return self._name
        }set{
            self._name = newValue
        }
    }
    
    var email: String{
        get{
            return self._email
        }set{
            self._email = newValue
        }
    }
    
    var major: [String]{
        get{
            return self._major
        }set{
            self._major = newValue
        }
    }
    
    var bio: String?{
        get{
            if self._bio == nil{
                return " "
            }
            return self._bio
        }set{
            self._bio = newValue
        }
    }
    var ideas: [IdeaData]?{
        get{
            return self._ideas
        }set{
            self._ideas = newValue
        }
    }
    
    
    
}
