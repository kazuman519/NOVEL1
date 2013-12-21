//
//  TitleLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/17.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "GameData.h"
#import "MenuScene.h"
#import "ArchiveLayer.h"
#import "HelpLayer.h"
#import "SystemLayer.h"

@interface TitleLayer : CCLayer {
    CGSize winSize_;
    GameData* gameData_;
    
    CCSprite* bgSprite_;
    CCMenuItemSprite* startBtn_;
    CCMenuItemSprite* continuBtn_;
    CCMenuItemSprite* archiveBtn_;
    CCMenuItemSprite* helpBtn_;
    CCMenuItemSprite* optionBtn_;
}

@end
