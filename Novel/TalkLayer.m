//
//  TalkLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "TalkLayer.h"
#import "MenuScene.h"


@implementation TalkLayer
enum {
    OBJECT_NULL,
    OBJECT_BACKGROUND,
    OBJECT_CHARACTER,
    OBJECT_TEXT_WINDOW,
    OBJECT_LINES_LABEL,
    OBJECT_CHAR_LABEL,
    OBJECT_PEN,
    OBJECT_FRONT,
    OBJECT_MENU,
    OBJECT_SIDE_BAR
};

-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        zeroPos_ = ccp(winSize_.width/2-240, 0);
        gameData_ = [GameData getInstance];
        
        [self initValue];
        [self initLayout];
    }
    return self;
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    
    [self textShow];
    
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) onExit
{
	// CCTouchDispatcherから登録を削除します
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	
	// 忘れずにスーパークラスのonExitをコールします
	[super onExit];
}

// 値の初期化
-(void)initValue{
    maxLineNum_ = 3;
    maxLineLength_ = 29;
    nowTextLength_ = 0;
    lineDuring_ = 10;
    fontSize_ = 15.5f;
    delayTime_ = 0.03f;
    progressTime_ = 0.0f;
    showText_ = [NSString string];
    
    isShowText_ = NO;
    isSkip_ = NO;
    
    textNum = 0;
    
    [gameData_ setTextAppontCharID:1];
    self.textArray = gameData_.textArray;
    self.nameArray = gameData_.charNameArray;
    self.inCharArray = gameData_.inCharArray;
    self.outCharArray = gameData_.outCharArray;
    self.labelArray = [NSMutableArray array];
    self.charArray = [NSMutableArray array];
    self.charIDArray = [NSMutableArray array];
    self.charPosArray = [NSMutableArray array];
    
    int division = 3;
    for (int i = 0; i <= division+1; i++) {
        CGPoint charPos = ccp(zeroPos_.x + 480/(division+1)*i,winSize_.height*0.4);
        [self.charPosArray addObject:[NSValue valueWithCGPoint:charPos]];
        NSLog(@"num:%d xpos:%f",i,charPos.x);
    }
}

// レイアウト初期化
-(void)initLayout{
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
    
    // 背景
    bgSprite_ = [CCSprite spriteWithFile:@"bg1.JPG"];
    bgSprite_.position = ccp(winSize_.width/2, winSize_.height/2);
    [self addChild:bgSprite_];
    
    // メニューボタン
    menuBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menuBtn.png"] selectedSprite:[CCSprite spriteWithFile:@"menuBtn.png"] block:^(id sender) {
        NSLog(@"MENU");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene node]]];
    }];
    menuBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.63, winSize_.height - menuBtn_.contentSize.height/2);
    
    CCMenu* menu = [CCMenu menuWithItems:menuBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu z:OBJECT_MENU];
    
    // テキストウィンドウ
    textWindow_ = [CCSprite spriteWithFile:@"textWindow.png"];
    textWindow_.anchorPoint = ccp(0.0, 1.0);
    textWindow_.position = ccp(winSize_.width/2 - textWindow_.contentSize.width/2, textWindow_.contentSize.height);
    [self addChild:textWindow_ z:OBJECT_TEXT_WINDOW tag:OBJECT_TEXT_WINDOW];
    
    // ペン
    penSprite_ = [CCSprite spriteWithFile:@"pen.png"];
    penSprite_.position = penPos_ = ccp(textWindow_.position.x + textWindow_.contentSize.width - penSprite_.contentSize.width, textWindow_.position.y - textWindow_.contentSize.height + penSprite_.contentSize.height*1.1);
    penSprite_.visible = NO;
    [self addChild:penSprite_ z:OBJECT_PEN tag:OBJECT_PEN];
    
    // 名前ラベル
    charNameLabel_ = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:20];
    charNameLabel_.color = ccBLACK;
    charNameLabel_.anchorPoint = ccp(0, 0);
    charNameLabel_.position = ccp(textWindow_.position.x+winSize_.height*0.03, textWindow_.position.y - charNameLabel_.contentSize.height*1.1);
    [self addChild:charNameLabel_ z:OBJECT_CHAR_LABEL tag:OBJECT_CHAR_LABEL];
    
    // テキストラベル
    self.labelArray = [NSMutableArray array];
    for (int i = 0; i < maxLineNum_; i++) {
        CCLabelTTF *textLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:fontSize_];
        textLabel.anchorPoint = ccp(0, 1.0);
        textLabel.position = ccp(textWindow_.position.x+winSize_.height*0.04, textWindow_.position.y-winSize_.height*0.12 - (textLabel.contentSize.height + lineDuring_)*i);
        [self.labelArray addObject:textLabel];
        [self addChild:textLabel z:OBJECT_LINES_LABEL tag:OBJECT_LINES_LABEL];
    }
    
    // フロント
    frontGround_ = [CCSprite spriteWithFile:@"blackFront.jpg"];
    frontGround_.position = ccp(winSize_.width/2, winSize_.height/2);
    frontGround_.opacity = 0;
    [self addChild:frontGround_ z:OBJECT_FRONT];
}
// ペンのアクション
-(void)jumpPen{
    penSprite_.visible = YES;
    penSprite_.position = penPos_;
    id jumpBy = [CCJumpBy actionWithDuration:100 position:ccp(0, 0) height:5 jumps:300];
    [penSprite_ runAction:jumpBy];
}
-(void)stopPen{
    penSprite_.visible = NO;
    [penSprite_ stopAllActions];
}

//次のテキストを表示させる
-(void)nextText{
    for (CCLabelTTF* label in self.labelArray){
        label.string = @"";
    }
    nowTextLength_ = 0;
    progressTime_ = 0;
    isSkip_ = NO;
    textNum++;
    [self stopPen];
    if (textNum < self.textArray.count) {
        [self textShow];
    }
    else{
        // パートのテキストが終了したら
        NSLog(@"PART END");
        [gameData_ advanceTime];
        [gameData_ advancePartAppointCharID:1];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuScene node]]];
    }
}

// テキストを登録
-(void)textShow{
    showText_ = [self.textArray objectAtIndex:textNum];
    charNameLabel_.string = [self.nameArray objectAtIndex:textNum];
    
    
    // 演出があるかのチェック
    NSNumber* inChar = [self.inCharArray objectAtIndex:textNum];
    NSNumber* outChar = [self.outCharArray objectAtIndex:textNum];
    if (inChar.floatValue != 0.0f) {
        [self inCharAction:inChar.floatValue];
    }
    if (outChar.floatValue != 0.0f) {
        [self outCharAction:outChar.floatValue];
    }
    
    isShowText_ = YES;
    [self schedule:@selector(textUp:)];
}
// テキストを１文字づつ、もしくは一括で表示する
-(void)textUp:(ccTime)delta{
    if (nowTextLength_ < showText_.length && isShowText_) {
        if (isSkip_) {
            nowTextLength_ = showText_.length;
            int needLineNum = showText_.length / maxLineLength_;
            for (int i = 0; i <= needLineNum; i++) {
                CCLabelTTF *label = [self.labelArray objectAtIndex:i];
                if (i == needLineNum) {
                    label.string = [showText_ substringWithRange:NSMakeRange(i*maxLineLength_, showText_.length-maxLineLength_*needLineNum)];
                }
                else{
                    label.string = [showText_ substringWithRange:NSMakeRange(i*maxLineLength_, maxLineLength_)];
                }
            }
        }
        else if (progressTime_ >= delayTime_) {
            progressTime_=0.0;
            nowTextLength_++;
            int lineNum = nowTextLength_/(maxLineLength_+1);
            CCLabelTTF* label = [self.labelArray objectAtIndex:lineNum];
            label.string = [showText_ substringWithRange:NSMakeRange(lineNum * maxLineLength_, nowTextLength_ - lineNum * maxLineLength_) ];
        }
        
        if (nowTextLength_ == showText_.length) {
            NSLog(@"END!!");
            isShowText_ = NO;
            [self jumpPen];
        }
    }
    else{
        //NSLog(@"全文出力");
        [self unschedule:@selector(textUp:)];
    }
    progressTime_ += delta;
}

// キャラクターを登場させるアクション
-(void)inCharAction:(float)num{
    NSLog(@"IN%f",num);
    int charID = num;
    int pos = (int)(num * 10) % 10;
    BOOL isAlready = NO;
    CCSprite* charSprite;
    
    int i = 0;
    for (NSNumber* charIDNum in self.charIDArray){
        if (charIDNum.intValue == charID) {
            charSprite = [self.charArray objectAtIndex:i];
            isAlready = YES;
        }
        i++;
    }
    if (!isAlready) {
        charSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"char%d_1.png",charID]];
        if (pos >=2) {
            charSprite.position = ccp(winSize_.width + charSprite.contentSize.width, winSize_.height*0.2);
        }else{
            charSprite.position = ccp(-charSprite.contentSize.width, winSize_.height*0.2);
        }
        [self addChild:charSprite];
        [self.charArray addObject:charSprite];
        [self.charIDArray addObject:[NSNumber numberWithInt:num]];
    }
    NSValue* posValue = [self.charPosArray objectAtIndex:pos];
    id moveTo = [CCMoveTo actionWithDuration:0.4 position:ccp(posValue.CGPointValue.x, winSize_.height*0.2)];
    [charSprite runAction:moveTo];
}
// キャラクターが画面外に出るアクション
-(void)outCharAction:(float)num{
    NSLog(@"OUT%f",num);
    int charID = num;
    int i = 0;
    for (NSNumber* charIDNum in self.charIDArray){
        NSLog(@"nubmeer%d",charIDNum.intValue);
        if (charIDNum.intValue == charID) {
            CCSprite* charSprite = [self.charArray objectAtIndex:i];
            
            id moveTo;
            if (charSprite.position.x > winSize_.width/2) {
                moveTo = [CCMoveTo actionWithDuration:0.3 position:ccp(winSize_.width+charSprite.contentSize.width, charSprite.position.y)];
            }else{
                moveTo = [CCMoveTo actionWithDuration:0.3 position:ccp(-charSprite.contentSize.width, charSprite.position.y)];
            }
            [charSprite runAction:moveTo];
        }
        i++;
    }
}

//--------- 画面アクション -------
// 暗転
-(void)blackOutAction{
    [frontGround_ setTexture:[[CCTextureCache sharedTextureCache] addImage: @"blackFront.jpg"]];
    id fadeTo1 = [CCFadeTo actionWithDuration:0.15 opacity:255];
    id delay = [CCDelayTime actionWithDuration:0.5];
    id fadeTo2 = [CCFadeTo actionWithDuration:0.25 opacity:0];
    [frontGround_ runAction:[CCSequence actions:fadeTo1, delay, fadeTo2, nil]];
}
// ホワイトアウト
-(void)whiteOutAction{
    [frontGround_ setTexture:[[CCTextureCache sharedTextureCache] addImage: @"whiteFront.jpg"]];
    id fadeTo1 = [CCFadeTo actionWithDuration:0.15 opacity:255];
    id delay = [CCDelayTime actionWithDuration:0.5];
    id fadeTo2 = [CCFadeTo actionWithDuration:0.25 opacity:0];
    [frontGround_ runAction:[CCSequence actions:fadeTo1, delay, fadeTo2, nil]];
}


//---- タッチ処理 ----
// タッチ開始
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL isBlock = NO;
    
    // タッチ座標を、cocos2d座標に変換します
    CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if (CGRectContainsPoint(textWindow_.boundingBox, location)) {
        if (!isShowText_) {
            NSLog(@"NEXT");
            [self nextText];
        }
        else{
            NSLog(@"SKIP");
            isSkip_ = YES;
        }
    }
    return isBlock;
}
// タッチ中移動
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
}
// タッチ終了
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
}
@end
