//
//  SystemLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "SystemLayer.h"
#import "TitleLayer.h"


@implementation SystemLayer
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
    titleLabel_ = [CCLabelTTF labelWithString:@"システム" fontName:@"Marker Felt" fontSize:24];
    titleLabel_.anchorPoint = ccp(0, 1.0);
    titleLabel_.position = titleLabelPos_ = ccp(winSize_.width/2 - winSize_.height*0.6, winSize_.height - winSize_.height*0.05);
    [self addChild:titleLabel_];
    
    [CCMenuItemFont setFontSize:18];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    returnBtn_ = [CCMenuItemFont itemWithString:@"もどる" block:^(id sender) {
        NSLog(@"RETURN");
        [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
        self.isReturn = YES;
    }];
    returnTitleBtn_ = [CCMenuItemFont itemWithString:@"タイトルへ" block:^(id sender){
        NSLog(@"RETURN TITLE");
        [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer node] ]];
    }];
    
    returnBtn_.position = returnBtnPos_ = ccp(winSize_.width/2 + winSize_.height*0.5, returnBtn_.contentSize.height);
    returnTitleBtn_.position = returnTitleBtnPos_ = ccp(winSize_.width/2, winSize_.height*0.5);
    
    CCMenu* menu = [CCMenu menuWithItems:returnBtn_, returnTitleBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

-(void)showAction{
    [self movePosNode:titleLabel_ position:titleLabelPos_];
    [self movePosNode:returnBtn_ position:returnBtnPos_];
    [self movePosNode:returnTitleBtn_ position:returnTitleBtnPos_];
    
}
-(void)hideAction{
    id moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp(0, -winSize_.height)];
    [returnBtn_ runAction:moveBy];
    
    [self moveUpNode:titleLabel_];
    [self moveUpNode:returnTitleBtn_];
    
}
-(void)movePosNode:(CCNode*)node position:(CGPoint)positon{
    id moveTo = [CCMoveTo actionWithDuration:0.5 position:positon];
    [node runAction:moveTo];
}
-(void)moveUpNode:(CCNode*)node{
    id moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp(0, (winSize_.height + node.contentSize.height - node.position.y)*2)];
    [node runAction:moveBy];
}
@end
