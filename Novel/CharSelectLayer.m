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
    titleSprite_ = [CCSprite spriteWithFile:@"charSeleTitle.png"];
    titleSprite_.anchorPoint = ccp(0, 1.0);
    titleSprite_.position = titleSpritePos_ = ccp(zeroPos_.x, winSize_.height - winSize_.height*0.05);
    [self addChild:titleSprite_];
    
    returnBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"returnBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"returnBtn2.png"] block:^(id sender) {
        NSLog(@"RETURN");
        self.isReturn = YES;
    }];
    returnBtn_.position = returnBtnPos_ = ccp(winSize_.width/2 + winSize_.height*0.6, winSize_.height - returnBtn_.contentSize.height);
    
    CCMenu* menu = [CCMenu menuWithItems:returnBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    for (int i=0; i<self.charIDArray.count; i++) {
        CGPoint selectCharPos;
        NSNumber* charID = [self.charIDArray objectAtIndex:i];
        CCMenuItemSprite* selectChar = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"selectChar%d.png",charID.intValue]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"selectChar%d.png",charID.intValue]]  block:^(id sender) {
            NSLog(@"select:%d",charID.intValue);
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TalkLayer node] ]];
            
        }];
        selectChar.anchorPoint = ccp(0.0, 1.0);
        selectChar.position = selectCharPos = ccp(zeroPos_.x + winSize_.height*0.03 + selectChar.contentSize.width * (i%2), winSize_.height * 0.78 - selectChar.contentSize.height * (i/2));
        [menu addChild:selectChar];
        
        [self.selectCharArray addObject:selectChar];
        [self.selectCharPosArray addObject:[NSValue valueWithCGPoint:selectCharPos]];
    }
}

-(void)showAction{
    [self movePosNode:titleSprite_ position:titleSpritePos_];
    [self movePosNode:returnBtn_ position:returnBtnPos_];
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
