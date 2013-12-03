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
    titleLabel_ = [CCLabelTTF labelWithString:@"のべるげーむ" fontName:@"Marker Felt" fontSize:40];
    titleLabel_.anchorPoint = ccp(0.5, 1.0);
    titleLabel_.position = ccp(winSize_.width/2, winSize_.height);
    [self addChild:titleLabel_];
    
    
    [CCMenuItemFont setFontSize:16];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    startBtn_ = [CCMenuItemFont itemWithString:@"はじめから" block:^(id sender) {
        NSLog(@"GAME START");
        
        // 確認アラート
        // ※データが合った場合だけ確認ができるようなしょりにする
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"続きからのデータが削除されますがよろしいですか？"
                                  delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }];
    continuBtn_ = [CCMenuItemFont itemWithString:@"つづきから" block:^(id sender) {
        NSLog(@"CONTINUE");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node]]];
    }];
    archiveBtn_ = [CCMenuItemFont itemWithString:@"アーカイブ" block:^(id sender) {
        NSLog(@"ARCHIVE");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ArchiveLayer node]]];
    }];
    helpBtn_ = [CCMenuItemFont itemWithString:@"ヘルプ" block:^(id sender) {
        NSLog(@"HELP");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelpLayer node]]];
    }];
    optionBtn_ = [CCMenuItemFont itemWithString:@"オプション" block:^(id sender) {
        NSLog(@"OPTION");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SystemLayer node] ]];
        
    }];
    
    startBtn_.position = ccp(winSize_.width*0.1, winSize_.height*0.1);
    continuBtn_.position = ccp(winSize_.width*0.3, winSize_.height*0.1);
    archiveBtn_.position = ccp(winSize_.width*0.5, winSize_.height*0.1);
    helpBtn_.position = ccp(winSize_.width*0.7, winSize_.height*0.1);
    optionBtn_.position = ccp(winSize_.width*0.9, winSize_.height*0.1);
    
    
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
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            NSLog(@"おk");
            [gameData_ newData];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node]]];
            break;
    }
    
}
@end
