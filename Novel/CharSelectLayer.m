//
//  CharSelectLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "CharSelectLayer.h"

@implementation CharSelectLayer
-(id)init{
    if (self=[super init]) {
        // 値の初期化
        winSize_ = [[CCDirector sharedDirector] winSize];
        zeroPos_ = ccp(winSize_.width/2- 240, 0);
        gameData_ = [GameData getInstance];
        
        self.charIDArray = [gameData_ getAppearanceCharID];
        self.selectCharArray = [NSMutableArray array];
        self.selectCharPosArray = [NSMutableArray array];
        self.isReturn = NO;
        
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    // タイトル
    titleSprite_ = [CCSprite spriteWithFile:@"charSeleTitle.png"];
    titleSprite_.anchorPoint = ccp(0, 1.0);
    titleSprite_.position = titleSpritePos_ = ccp(zeroPos_.x, winSize_.height - winSize_.height*0.05);
    [self addChild:titleSprite_];
    
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
    
    
    // 選択キャラクター
    NSMutableArray *layerArray = [NSMutableArray array];
    for (int i=0; i<self.charIDArray.count; i++) {
        int pageNum = i/2;
        CCLayer* layer = [CCLayer node];
        if (layerArray.count == pageNum) {
            [layerArray addObject:layer];
        }else{
            layer = [layerArray objectAtIndex:pageNum];
        }
        
        CGPoint selectCharPos;
        NSNumber* charID = [self.charIDArray objectAtIndex:i];
        CCMenuItemSprite* selectChar = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"selectChar%d.png",charID.intValue]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"selectChar%d.png",charID.intValue]]  block:^(id sender) {
            NSLog(@"SELECT_CHAR:%d",charID.intValue);
            [gameData_ setTextAppontCharID:0];
            [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TalkLayer node] ]];
            
        }];
        selectChar.anchorPoint = ccp(0.0, 1.0);
        selectChar.position = selectCharPos = ccp(zeroPos_.x + winSize_.height*0.03 + selectChar.contentSize.width * (i%2), winSize_.height * 0.78 - selectChar.contentSize.height * (0));
        CCMenu* menu1 = [CCMenu menuWithItems:selectChar, nil];
        menu1.position = ccp(0, 0);
        [layer addChild:menu1];
        
        [self.selectCharArray addObject:selectChar];
        [self.selectCharPosArray addObject:[NSValue valueWithCGPoint:selectCharPos]];
    }
    // CCScrollLayerに突っ込む
    scroller_ = [[CCScrollLayer alloc] initWithLayers:layerArray widthOffset: 0];
    scroller_.pagesIndicatorPosition = scrollerIndicatorPos_ = ccp(winSize_.width/2, 20);
    [self addChild:scroller_];
}

-(void)showAction{
    [self movePosNode:titleSprite_ position:titleSpritePos_];
    [self movePosNode:returnBtn_ position:returnBtnPos_];
    scroller_.pagesIndicatorPosition = scrollerIndicatorPos_;
    scroller_.touchEnabled = YES;
    int i = 0;
    for (CCMenuItemSprite* selectChar in self.selectCharArray){
        NSValue* posValue = [self.selectCharPosArray objectAtIndex:i];
        [self movePosNode:selectChar position:[posValue CGPointValue]];
        i++;
    }
}
-(void)hideAction{
    [self moveUpNode:returnBtn_];
    [self moveUpNode:titleSprite_];
    scroller_.pagesIndicatorPosition = ccp(0, -50);
    scroller_.touchEnabled = NO;
    for (CCMenuItemSprite* selectChar in self.selectCharArray){
        [self moveDownNode:selectChar];
    }
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
