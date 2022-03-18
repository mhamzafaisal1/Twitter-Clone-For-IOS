//
//  UploadTweetViewModel.swift
//  TwitterCl
//
//  Created by Abdullah on 13/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeHolderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            //If tweeting
            actionButtonTitle = "Tweet"
            placeHolderText = "What's happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            //If replying
            actionButtonTitle = "Reply"
            placeHolderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "replyig to @\(tweet.user.username)"
        }
    }
    
}
