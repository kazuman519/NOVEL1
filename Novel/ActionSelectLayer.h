//
//  ActionSelectLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"

@interface ActionSelectLayer : CCLayer {
    CGSize winSize_;
    GameData *gameData_;
    
    CCLabelTTF* dayLabel_;
    CCMenuItemFont* talkBtn_;
    CCMenuItemFont* itemBtn_;
    CCMenuItemFont* dataBtn_;
    CCMenuItemFont* shopBtn_;
    CCMenuItemFont* systemBtn_;
    
    CGPoint dayLabelPos_;
    CGPoint talkBtnPos_;
    CGPoint itemBtnPos_;
    CGPoint dataBtnPos_;
    CGPoint shopBtnPos_;
    CGPoint systemBtnPos_;
    
    float day_;
}

@property BOOL isShowTalk;
@property BOOL isShowItem;
@property BOOL isShowData;
@property BOOL isShowShop;
@property BOOL isShowSystem;

-(void)showAction;
-(void)hideAction;
@end
