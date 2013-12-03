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
        gameData_ = [GameData getInstance];
        
        self.nameArray = [gameData_ getAppearanceCharName];
        self.nameBarArray = [NSMutableArray array];
        self.nameBarPosArray = [NSMutableArray array];
        self.isReturn = NO;
        
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    titleLabel_ = [CCLabelTTF labelWithString:@"会話相手一覧" fontName:@"Marker Felt" fontSize:30];
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
    
    for (int i=0; i<self.nameArray.count; i++) {
        CGPoint nameBarPos;
        NSString* charName = [self.nameArray objectAtIndex:i];
        CCMenuItemFont* nameBar = [CCMenuItemFont itemWithString:charName block:^(id sender) {
            NSLog(@"select:%@",charName);
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TalkLayer node] ]];
            
        }];
        nameBar.fontSize=18;
        nameBar.fontName = @"Marker Felt";
        nameBar.position = nameBarPos = ccp(winSize_.width/2 - winSize_.height*0.2, titleLabel_.position.y - winSize_.height*0.2 - winSize_.height *0.17 * i);
        [menu addChild:nameBar];
        
        [self.nameBarArray addObject:nameBar];
        [self.nameBarPosArray addObject:[NSValue valueWithCGPoint:nameBarPos]];
    }
}

-(void)showAction{
    [self movePosNode:titleLabel_ position:titleLabelPos_];
    [self movePosNode:returnBtn_ position:returnBtnPos_];
    int i = 0;
    for (CCLabelTTF* nameBar in self.nameBarArray){
        NSValue* posValue = [self.nameBarPosArray objectAtIndex:i];
        [self movePosNode:nameBar position:[posValue CGPointValue]];
        i++;
    }
}
-(void)hideAction{
    [self moveDownNode:returnBtn_];
    [self moveUpNode:titleLabel_];
    for (CCLabelTTF* nameBar in self.nameBarArray){
        [self moveDownNode:nameBar];
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
