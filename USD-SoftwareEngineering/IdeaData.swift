//
//  IdeaData.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation

class IdeaData{
    //MARK: Private vars
    //Idea data
    private var _ideaReference: String!
    private var _ideaTitle: String!
    private var _ideaSubtitle: String!
    private var _ideaDescription: String!
    private var _roles: [String]!
    
    //Author data
    private var _ideaAuthorUID: String!
    private var _ideaAuthorName: String!
    private var _ideaAuthorMajor: [String]!
    
    //Timing
    private var _timestamp: Double!
    private var _dateString: String!
    
    //Feedback
    private var _comments: [IdeaCommentData]?
    private var _interestedUsers: [UserData]?
    
    
    //MARK: Init
    
    //For pulling/displaying idea in (1) idea feed, (2) user profile
    init(ideaReference: String, ideaTitle: String, ideaSubtitle: String, ideaDescription: String, roles: [String], ideaAuthorUID: String, timestamp: Double){
        self._ideaReference = ideaReference
        self._ideaTitle = ideaTitle
        self._ideaSubtitle = ideaSubtitle
        self._ideaDescription = ideaDescription
        self._roles = roles
        self._ideaAuthorUID = ideaAuthorUID
        self._timestamp = timestamp
    
    }
    
    //For pulling/displaying idea in idea details view
    init(ideaReference: String, ideaTitle: String, ideaSubtitle: String, ideaDescription: String, roles: [String], ideaAuthorUID: String, ideaAuthorName: String, ideaAuthorMajor: [String], comments: [IdeaCommentData], interestedUsers: [UserData], timestamp: Double) {
        self._ideaReference = ideaReference
        self._ideaTitle = ideaTitle
        self._ideaSubtitle = ideaSubtitle
        self._ideaDescription = ideaDescription
        self._roles = roles
        
        self._ideaAuthorUID = ideaAuthorUID
        self._ideaAuthorName = ideaAuthorName
        self._ideaAuthorMajor = ideaAuthorMajor
        
        self._comments = comments
        self._interestedUsers = interestedUsers
        
        self._timestamp = timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = Date(timeIntervalSince1970: timestamp)
        self._dateString = dateFormatter.string(from: date)
    }
    
    
    //For submitting a new idea (lacks feedback params)
    init(ideaReference: String, ideaTitle: String, ideaSubtitle: String, ideaDescription: String, roles: [String], ideaAuthorUID: String, ideaAuthorName: String, ideaAuthorMajor: [String], timestamp: Double) {
        self._ideaReference = ideaReference
        self._ideaTitle = ideaTitle
        self._ideaSubtitle = ideaSubtitle
        self._ideaDescription = ideaDescription
        self._roles = roles
        
        self._ideaAuthorUID = ideaAuthorUID
        self._ideaAuthorName = ideaAuthorName
        self._ideaAuthorMajor = ideaAuthorMajor
        
        self._timestamp = timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = Date(timeIntervalSince1970: timestamp)
        self._dateString = dateFormatter.string(from: date)
    }
    
    //MARK: Public vars
    //Idea data
    var ideaReference: String{
        return _ideaReference
    }
    var ideaTitle: String{
        return _ideaTitle
    }
    var ideaSubtitle: String{
        return _ideaSubtitle
    }
    var ideaDescription: String{
        return _ideaDescription
    }
    var roles: [String]{
        return _roles
    }
    
    //Author data
    var ideaAuthorUID: String{
        return _ideaAuthorUID
    }
    var ideaAuthorName: String{
        return _ideaAuthorName
    }
    var ideaAuthorMajor: [String]{
        return _ideaAuthorMajor
    }
    
    //Timing
    var timestamp: Double{
        return _timestamp
    }
    var dateString: String{
        return _dateString
    }
    
    //Feedback
    var comments: [IdeaCommentData]?{
        return _comments
    }
    var interestedUsers: [UserData]?{
        return _interestedUsers
    }
    

}
