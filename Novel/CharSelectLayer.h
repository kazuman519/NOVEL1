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
    GameData* gameData_;
    
    CCLabelTTF* titleLabel_;
    CCMenuItemFont* returnBtn_;
    
    CGPoint titleLabelPos_;
    CGPoint returnBtnPos_;
}

@property (nonatomic,retain) NSMutableArray* nameArray;
@property (nonatomic,retain) NSMutableArray* nameBarArray;
@property (nonatomic,retain) NSMutableArray* nameBarPosArray;
@property BOOL isReturn;

-(void)showAction;
-(void)hideAction;
@end
