//
//  TextLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/12.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TextLayer : CCLayer {
    CGSize winSize_;
    CCSprite* textWindow_;
    CCLabelTTF* charNameLabel_;
    
    int maxLineNum_;
    int maxLineLength_;
    int nowTextLength_;
    int lineDuring_;
    int fontSize_;
    float delayTime_;
    float progressTime_;
    NSString *showText_;
    
    BOOL isShowText_;
    BOOL isSkip_;
}

@property (nonatomic,retain)NSMutableArray* labelArray;
@end
