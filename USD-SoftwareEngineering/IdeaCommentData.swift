//
//  IdeaCommentData.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation

class IdeaCommentData{
    private var _ideaCommentAuthorName: String!
    private var _ideaCommentAuthorUID: String!
    private var _ideaCommentText: String!
    private var _timestamp: Double!
    private var _dateString: String!
    
    init(ideaCommentAuthorName: String, ideaCommentAuthorUID: String, ideaCommentText: String, timestamp: Double){
        self._ideaCommentAuthorName = ideaCommentAuthorName
        self._ideaCommentAuthorUID = ideaCommentAuthorUID
        self._ideaCommentText = ideaCommentText
        self._timestamp = timestamp
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = Date(timeIntervalSince1970: timestamp)
        self._dateString = dateFormatter.string(from: date)
    }

    var ideaCommentAuthorName: String{
        return self._ideaCommentAuthorName
    }
    var ideaCommentAuthorUID: String{
        return self._ideaCommentAuthorUID
    }
    var ideaCommentText: String{
        return self._ideaCommentText
    }
    var timestamp: Double{
        return _timestamp
    }
    var dateString: String{
        return _dateString
    }
    
}
