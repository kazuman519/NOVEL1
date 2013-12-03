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
    titleLabel_ = [CCLabelTTF labelWithString:@"クラスメイト　データ" fontName:@"Marker Felt" fontSize:24];
    titleLabel_.anchorPoint = ccp(0, 1.0);
    titleLabel_.position = titleLabelPos_ = ccp(winSize_.width/2 - winSize_.height*0.6, winSize_.height - winSize_.height*0.05);
    [self addChild:titleLabel_];
    
    [CCMenuItemFont setFontSize:18];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    returnBtn_ = [CCMenuItemFont itemWithString:@"もどる" block:^(id sender) {
        NSLog(@"RETURN");
        self.isReturn = YES;
    }];
    returnBtn_.position = returnBtnPos_ = ccp(winSize_.width/2 + winSize_.height*0.5, returnBtn_.contentSize.height);
    
    CCMenu* menu = [CCMenu menuWithItems:returnBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

-(void)showAction{
    [self movePosNode:titleLabel_ position:titleLabelPos_];
    [self movePosNode:returnBtn_ position:returnBtnPos_];
    
}
-(void)hideAction{
    [self moveDownNode:returnBtn_];
    [self moveUpNode:titleLabel_];
    
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
