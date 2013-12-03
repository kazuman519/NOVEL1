//
//  ActionSelectLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "ActionSelectLayer.h"



@implementation ActionSelectLayer
-(id)init{
    if (self=[super init]) {
        // 値の初期化
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        self.isShowTalk = NO;
        self.isShowItem = NO;
        self.isShowData = NO;
        self.isShowShop = NO;
        self.isShowSystem = NO;
        
        day_ = [gameData_ getDay];
        
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    dayLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"12\n月\n%1.0f\n日\n(月)",day_] fontName:@"Marker Felt" fontSize:20];
    dayLabel_.anchorPoint = ccp(0.5, 1.0);
    dayLabel_.position = dayLabelPos_ = ccp(winSize_.width/2 + winSize_.height * 0.6, winSize_.height*0.8);
    [self addChild:dayLabel_];
    
    [CCMenuItemFont setFontSize:18];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    talkBtn_ = [CCMenuItemFont itemWithString:@"会話" block:^(id sender) {
        NSLog(@"TALK");
        self.isShowTalk = YES;
        [self hideAction];
        [gameData_ nextTime];
    }];
    itemBtn_ = [CCMenuItemFont itemWithString:@"アイテム" block:^(id sender) {
        NSLog(@"ITEM");
        self.isShowItem = YES;
        [self hideAction];
    }];
    dataBtn_ = [CCMenuItemFont itemWithString:@"データ" block:^(id sender) {
        NSLog(@"DATA");
        self.isShowData = YES;
        [self hideAction];
    }];
    shopBtn_ = [CCMenuItemFont itemWithString:@"ショップ" block:^(id sender) {
        NSLog(@"SHOP");
        self.isShowShop = YES;
        [self hideAction];
    }];
    systemBtn_ = [CCMenuItemFont itemWithString:@"システム" block:^(id sender) {
        NSLog(@"SYSTEM");
        self.isShowSystem = YES;
        [self hideAction];
    }];
    
    talkBtn_.position = talkBtnPos_= ccp(winSize_.width/2 - winSize_.height * 0.7, winSize_.height*0.5);
    itemBtn_.position = itemBtnPos_ = ccp(winSize_.width/2 - winSize_.height * 0.5, winSize_.height*0.45);
    dataBtn_.position  = dataBtnPos_ = ccp(winSize_.width/2 - winSize_.height * 0.35, winSize_.height*0.35);
    shopBtn_.position = shopBtnPos_ = ccp(winSize_.width/2 - winSize_.height * 0.25, winSize_.height*0.2);
    systemBtn_.position = systemBtnPos_ = ccp(winSize_.width/2 - winSize_.height * 0.2, winSize_.height*0.1);
    
    
    CCMenu* menu = [CCMenu menuWithItems:talkBtn_, itemBtn_, dataBtn_, shopBtn_, systemBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

-(void)showAction{
    [self movePosNode:dayLabel_ position:dayLabelPos_];
    [self movePosNode:talkBtn_ position:talkBtnPos_];
    [self movePosNode:itemBtn_ position:itemBtnPos_];
    [self movePosNode:dataBtn_ position:dataBtnPos_];
    [self movePosNode:shopBtn_ position:shopBtnPos_];
    [self movePosNode:systemBtn_ position:systemBtnPos_];
}
-(void)hideAction{
    id moveBy1 = [CCMoveBy actionWithDuration:0.5 position:ccp(winSize_.width/2, 0)];
    [dayLabel_ runAction:moveBy1];
    
    [self moveLeftNode:talkBtn_];
    [self moveLeftNode:itemBtn_];
    [self moveLeftNode:dataBtn_];
    [self moveLeftNode:shopBtn_];
    [self moveLeftNode:systemBtn_];
}
-(void)movePosNode:(CCNode*)node position:(CGPoint)positon{
    id moveTo = [CCMoveTo actionWithDuration:0.5 position:positon];
    [node runAction:moveTo];
}
-(void)moveLeftNode:(CCNode*)node{
    id moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp(-node.position.x*3, 0)];
    [node runAction:moveBy];
}
@end
