//
//  StoryChallengeModel.swift
//  TalkDrawing
//
//  Created by Changjun Li on 2023/7/29.
//

import Foundation

struct StoryChallengeModel {
    let id = UUID().uuidString
    // 板块标题和图片
    let title: String
    // 板块年龄段
    let age = 1
    // 是否已经解锁
    var ifLocked: Bool = true
    
    static let storyChallenges = [
        StoryChallengeModel(title: "童话寓言"),
        StoryChallengeModel(title: "经典儿歌"),
        StoryChallengeModel(title: "国学诗词"),
        StoryChallengeModel(title: "传统文化"),
        StoryChallengeModel(title: "历史人文"),
        StoryChallengeModel(title: "自然百科"),
    ]
}
