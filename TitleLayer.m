//
//  TitleLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/17.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "TitleLayer.h"


@implementation TitleLayer
-(id)init{
    if (self=[super init]) {
        // 値の初期化
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    float randomValue = CCRANDOM_0_1();
    int number;
    if (randomValue < 0.5) {
        number = 1;
    }else{
        number = 2;
    }
    
    bgSprite_ = [CCSprite spriteWithFile:[NSString stringWithFormat:@"titleBg%d.png",number]];
    bgSprite_.position = ccp(winSize_.width/2, winSize_.height/2);
    [self addChild:bgSprite_];

    
    [CCMenuItemFont setFontSize:16];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    startBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"startBtn%d_1.png",number]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"startBtn%d_2.png",number]] block:^(id sender) {
        NSLog(@"GAME START");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        
        // 確認アラート
        // ※データが合った場合だけ確認ができるようなしょりにする
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"続きからのデータが削除されますがよろしいですか？"
                                  delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }];
    continuBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"continueBtn%d_1.png",number]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"continueBtn%d_2.png",number]] block:^(id sender) {
        NSLog(@"CONTINUE");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node]]];
    }];
    archiveBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"archiveBtn%d_1.png",number]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"archiveBtn%d_2.png",number]] block:^(id sender) {
        NSLog(@"ARCHIVE");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ArchiveLayer node]]];
    }];
    helpBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"helpBtn%d_1.png",number]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"helpBtn%d_2.png",number]] block:^(id sender) {
        NSLog(@"HELP");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelpLayer node]]];
    }];
    optionBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"optionBtn%d_1.png",number]] selectedSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"optionBtn%d_2.png",number]] block:^(id sender) {
        NSLog(@"OPTION");
        [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SystemLayer node] ]];
        
    }];
    
    startBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.5, winSize_.height*0.8);
    continuBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.5, winSize_.height*0.65);
    archiveBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.5, winSize_.height*0.5);
    helpBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.5, winSize_.height*0.35);
    optionBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.5, winSize_.height*0.2);
    
    
    CCMenu* menu = [CCMenu menuWithItems:startBtn_, continuBtn_, archiveBtn_, helpBtn_, optionBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            NSLog(@"だめ");
            [[SimpleAudioEngine sharedEngine] playEffect:@"return.wav"];
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            NSLog(@"おk");
            [gameData_ newData];
            [[SimpleAudioEngine sharedEngine] playEffect:@"tap.wav"];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node]]];
            break;
    }
    
}
@end
