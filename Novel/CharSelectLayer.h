//
//  CharSelectLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
#import "TalkLayer.h"

@interface CharSelectLayer : CCLayer {
    CGSize winSize_;
    CGPoint zeroPos_;
    GameData* gameData_;
    
    CCSprite* titleSprite_;
    CCMenuItemSprite* returnBtn_;
    
    CGPoint titleSpritePos_;
    CGPoint returnBtnPos_;
}

@property (nonatomic,retain) NSMutableArray* charIDArray;
@property (nonatomic,retain) NSMutableArray* selectCharArray;
@property (nonatomic,retain) NSMutableArray* selectCharPosArray;
@property BOOL isReturn;

-(void)showAction;
-(void)hideAction;
@end
