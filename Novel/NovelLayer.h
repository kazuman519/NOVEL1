//
//  NovelLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/10/22.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"

@interface NovelLayer : CCLayer {
    CGSize winSize_;
    GameData* gameData_;
    
    CCSprite* textWindow_;
    CCSprite* charSprite_;
    CCLabelTTF* charNameLabel_;
    
    CGPoint reftPosition_;
    CGPoint lightPositon_;
    
    int part_;
    int textLength_;
    int lineNum_;
    int fontSize_;
    int lineDuring_;
    float delayTime_;
    
    // test
    float progressTime_;
    int showStringNum_;
    BOOL isSkip_;
    NSString* showTexttt_;
}

@property (nonatomic,retain)NSMutableArray* textArray;
@property (nonatomic,retain)NSMutableArray* labelArray;
@end
