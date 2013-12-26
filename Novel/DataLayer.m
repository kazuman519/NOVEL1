//
//  DataLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "DataLayer.h"


@implementation DataLayer
-(id)init{
    if (self=[super init]) {
        // 値の初期化
        winSize_ = [[CCDirector sharedDirector] winSize];
        
        self.isReturn = NO;
        
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    titleSprite_ = [CCSprite spriteWithFile:@"dataTitle.png"];
    titleSprite_.anchorPoint = ccp(0, 1.0);
    titleSprite_.position = titleSpritelPos_ = ccp(0, winSize_.height - winSize_.height*0.05);
    [self addChild:titleSprite_];
    
    [CCMenuItemFont setFontSize:18];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    // 戻るボタン
    returnBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"returnBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"returnBtn2.png"] block:^(id sender) {
        NSLog(@"RETURN");
        [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
        self.isReturn = YES;
    }];
    returnBtn_.position = returnBtnPos_ = ccp(winSize_.width/2 + winSize_.height*0.6, winSize_.height - returnBtn_.contentSize.height);
    
    CCMenu* menu = [CCMenu menuWithItems:returnBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

-(void)showAction{
    [self movePosNode:titleSprite_ position:titleSpritelPos_];
    [self movePosNode:returnBtn_ position:returnBtnPos_];
    
}
-(void)hideAction{
    [self moveUpNode:returnBtn_];
    [self moveUpNode:titleSprite_];
    
}
-(void)movePosNode:(CCNode*)node position:(CGPoint)positon{
    id moveTo = [CCMoveTo actionWithDuration:0.5 position:positon];
    [node runAction:moveTo];
}
-(void)moveUpNode:(CCNode*)node{
    id moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp(0, (winSize_.height + node.contentSize.height - node.position.y)*2)];
    [node runAction:moveBy];
}
-(void)moveDownNode:(CCNode*)node{
    id moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp(0, -node.position.y*2)];
    [node runAction:moveBy];
}
@end
