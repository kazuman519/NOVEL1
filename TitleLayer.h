//
//  TitleLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/17.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
#import "MenuScene.h"
#import "ArchiveLayer.h"
#import "HelpLayer.h"
#import "SystemLayer.h"

@interface TitleLayer : CCLayer {
    CGSize winSize_;
    GameData* gameData_;
    
    CCLabelTTF* titleLabel_;
    CCMenuItemFont* startBtn_;
    CCMenuItemFont* continuBtn_;
    CCMenuItemFont* archiveBtn_;
    CCMenuItemFont* helpBtn_;
    CCMenuItemFont* optionBtn_;
}

@end
