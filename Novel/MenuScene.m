//
//  MenuScene.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/28.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "MenuScene.h"
enum{
    OBJECT_OTHER,
    OBJECT_SIDE_BAR
};

@implementation MenuScene
-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];

        [self initLayer];
        [self initLayout];
        [self scheduleUpdate];
    }
    return self;
}

-(void)initLayer{
    // サイドバーの設定
    if (winSize_.width == 568) {
        CCSprite* leftBar = [CCSprite spriteWithFile:@"sideBar.png"];
        CCSprite* rightBar = [CCSprite spriteWithFile:@"sideBar.png"];
        leftBar.anchorPoint = ccp(0.0, 0);
        rightBar.anchorPoint = ccp(1.0, 0);
        leftBar.position = ccp(0, 0);
        rightBar.position = ccp(winSize_.width, 0);
        [self addChild:leftBar z:OBJECT_SIDE_BAR];
        [self addChild:rightBar z:OBJECT_SIDE_BAR];
    }
    actionSelectLayer_ = [ActionSelectLayer node];
    charSelectLayer_ = [CharSelectLayer node];
    itemLayer_ = [ItemLayer node];
    dataLayer_ = [DataLayer node];
    shopLayer_ = [ShopLayer node];
    systemLayer_ = [SystemLayer node];
    
    [self addChild:actionSelectLayer_];
    [self addChild:charSelectLayer_];
    [self addChild:itemLayer_];
    [self addChild:dataLayer_];
    [self addChild:shopLayer_];
    [self addChild:systemLayer_];
}

-(void)initLayout{
    [charSelectLayer_ hideAction];
    [itemLayer_ hideAction];
    [dataLayer_ hideAction];
    [shopLayer_ hideAction];
    [systemLayer_ hideAction];
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
}

-(void)onEnter{
    [super onEnter];
}

-(void)onExit{
    [super onExit];
}

-(void)update:(ccTime)delta{
    // 行動選択で何を選択されたかの判定
    if (actionSelectLayer_.isShowTalk) {
        actionSelectLayer_.isShowTalk = NO;
        [charSelectLayer_ showAction];
    }
    else if (actionSelectLayer_.isShowItem){
        actionSelectLayer_.isShowItem = NO;
        [itemLayer_ showAction];
    }
    else if (actionSelectLayer_.isShowData){
        actionSelectLayer_.isShowData = NO;
        [dataLayer_ showAction];
    }
    else if (actionSelectLayer_.isShowShop){
        actionSelectLayer_.isShowShop = NO;
        [shopLayer_ showAction];
    }
    else if (actionSelectLayer_.isShowSystem){
        actionSelectLayer_.isShowSystem = NO;
        [systemLayer_ showAction];
    }
    
    // 各レイヤーからの戻る判定
    if (charSelectLayer_.isReturn) {
        charSelectLayer_.isReturn = NO;
        [charSelectLayer_ hideAction];
        [actionSelectLayer_ showAction];
    }
    else if (itemLayer_.isReturn){
        itemLayer_.isReturn = NO;
        [itemLayer_ hideAction];
        [actionSelectLayer_ showAction];
    }
    else if (dataLayer_.isReturn){
        dataLayer_.isReturn = NO;
        [dataLayer_ hideAction];
        [actionSelectLayer_ showAction];
    }
    else if (shopLayer_.isReturn){
        shopLayer_.isReturn = NO;
        [shopLayer_ hideAction];
        [actionSelectLayer_ showAction];
    }
    else if (systemLayer_.isReturn){
        systemLayer_.isReturn = NO;
        [systemLayer_ hideAction];
        [actionSelectLayer_ showAction];
    }
    
}
@end
