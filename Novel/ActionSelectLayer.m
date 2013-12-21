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
        time_ = [gameData_ getTime];
        
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    // 背景
    bgSprite_ = [CCSprite spriteWithFile:@"classBg.png"];
    bgSprite_.position = ccp(winSize_.width/2, winSize_.height/2);
    [self addChild:bgSprite_];
    zeroPos_ = ccp(winSize_.width/2 - bgSprite_.contentSize.width/2, 0);
    
    // 左下の時間
    timeSprite_ = [CCSprite spriteWithFile:[NSString stringWithFormat:@"time%d.png",time_]];
    timeSprite_.anchorPoint = ccp(0, 0);
    timeSprite_.position = ccp(zeroPos_.x, 0);
    [self addChild:timeSprite_];
    
    // 日付表示させる画像
    daySprite_ = [CCSprite spriteWithFile:@"dayImage.png"];
    daySprite_.anchorPoint = ccp(0.5, 1.0);
    daySprite_.position = daySpritePos_ = ccp(winSize_.width/2 + winSize_.height * 0.6, winSize_.height*0.9);
    [self addChild:daySprite_];
    
    // 月のラベル
    monthLabel_ = [CCLabelTTF labelWithString:@"12" fontName:@"Marker Felt" fontSize:25];
    monthLabel_.position = monthLabelPos_ = ccp(daySpritePos_.x, daySpritePos_.y - daySprite_.contentSize.height*0.2);
    monthLabel_.color = ccBLACK;
    [self addChild:monthLabel_];
    
    
    // 日にちのラベル
    dayLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%1.0f",day_] fontName:@"Marker Felt" fontSize:27];
    dayLabel_.position = dayLabelPos_ = ccp(daySpritePos_.x, daySpritePos_.y - daySprite_.contentSize.height*0.6);
    dayLabel_.color = ccBLACK;
    [self addChild:dayLabel_];
    
    // ----- 各ボタン -----
    talkBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"talkBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"talkBtn2.png"] block:^(id sender) {
        NSLog(@"TALK");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        self.isShowTalk = YES;
        [self hideAction];
    }];
    itemBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"itemBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"itemBtn2.png"] block:^(id sender) {
        NSLog(@"ITEM");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        self.isShowItem = YES;
        [self hideAction];
    }];
    dataBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"dataBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"dataBtn2.png"] block:^(id sender) {
        NSLog(@"DATA");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        self.isShowData = YES;
        [self hideAction];
    }];
    shopBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"shopBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"shopBtn2.png"] block:^(id sender) {
        NSLog(@"SHOP");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        self.isShowShop = YES;
        [self hideAction];
    }];
    systemBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"systemBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"systemBtn2.png"] block:^(id sender) {
        NSLog(@"SYSTEM");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        self.isShowSystem = YES;
        [self hideAction];
    }];
    
    // 円形に配置
    float l = winSize_.height*0.917;
    talkBtn_.anchorPoint = itemBtn_.anchorPoint = dataBtn_.anchorPoint = shopBtn_.anchorPoint = systemBtn_.anchorPoint = ccp(1.0, 1.0);
    talkBtn_.position = talkBtnPos_= ccp(zeroPos_.x+l*cos(M_PI_2/6*5), l*sin(M_PI_2/6*5));
    itemBtn_.position = itemBtnPos_ = ccp(zeroPos_.x+l*cos(M_PI_2/6*4), l*sin(M_PI_2/6*4));
    dataBtn_.position  = dataBtnPos_ = ccp(zeroPos_.x+l*cos(M_PI_2/6*3), l*sin(M_PI_2/6*3));
    shopBtn_.position = shopBtnPos_ = ccp(zeroPos_.x+l*cos(M_PI_2/6*2), l*sin(M_PI_2/6*2));
    systemBtn_.position = systemBtnPos_ = ccp(zeroPos_.x+l*cos(M_PI_2/6*1), l*sin(M_PI_2/6*1));
    NSLog(@"aaaaa%f",M_PI_2/6*180/M_PI);
    
    
    CCMenu* menu = [CCMenu menuWithItems:talkBtn_, itemBtn_, dataBtn_, shopBtn_, systemBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

-(void)showAction{
    id rotateBy = [CCRotateBy actionWithDuration:0.45 angle:90];
    [timeSprite_ runAction:rotateBy];
    [self movePosNode:daySprite_ position:daySpritePos_];
    [self movePosNode:monthLabel_ position:monthLabelPos_];
    [self movePosNode:dayLabel_ position:dayLabelPos_];
    [self movePosNode:talkBtn_ position:talkBtnPos_];
    [self movePosNode:itemBtn_ position:itemBtnPos_];
    [self movePosNode:dataBtn_ position:dataBtnPos_];
    [self movePosNode:shopBtn_ position:shopBtnPos_];
    [self movePosNode:systemBtn_ position:systemBtnPos_];
}
-(void)hideAction{
    id rotateBy = [CCRotateBy actionWithDuration:0.2 angle:-90];
    [timeSprite_ runAction:rotateBy];
    
    [self moveRightNode:daySprite_];
    [self moveRightNode:monthLabel_];
    [self moveRightNode:dayLabel_];
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
-(void)moveRightNode:(CCNode*)node{
    id moveBy = [CCMoveBy actionWithDuration:0.5 position:ccp((winSize_.width - node.position.x)*3, 0)];
    [node runAction:moveBy];
}
@end
