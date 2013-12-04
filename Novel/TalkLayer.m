//
//  TalkLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "TalkLayer.h"


@implementation TalkLayer
enum {
    OBJECT_NULL,
    OBJECT_TEXT_WINDOW,
    OBJECT_LINES_LABEL,
    OBJECT_CHAR_LABEL,
    OBJECT_PEN
};

-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
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
    
    self.textArray = [NSMutableArray array];
    self.labelArray = [NSMutableArray array];
    
    [self.textArray addObject:@"あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろらりるれろ１２３４５６７８９０"];
    [self.textArray addObject:@"なんやててあ"];
    [self.textArray addObject:@"fowaejfoaweifao"];
}

// レイアウト初期化
-(void)initLayout{
    // メニューボタン
    menuBtn_ = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"menuBtn.png"] selectedSprite:[CCSprite spriteWithFile:@"menuBtn.png"] block:^(id sender) {
        NSLog(@"MENU");
    }];
    menuBtn_.position = ccp(winSize_.width/2 + winSize_.height*0.63, winSize_.height - menuBtn_.contentSize.height/2);
    
    CCMenu* menu = [CCMenu menuWithItems:menuBtn_, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
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
    charNameLabel_ = [CCLabelTTF labelWithString:@"unknown" fontName:@"Marker Felt" fontSize:25];
    charNameLabel_.color = ccBLACK;
    charNameLabel_.anchorPoint = ccp(0, 0);
    charNameLabel_.position = ccp(textWindow_.position.x+winSize_.height*0.03, textWindow_.position.y - charNameLabel_.contentSize.height);
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

-(void)nextText{
    for (CCLabelTTF* label in self.labelArray){
        label.string = @"";
    }
    nowTextLength_ = 0;
    progressTime_ = 0;
    isShowText_ = NO;
    isSkip_ = NO;
    textNum++;
    [self stopPen];
    if (textNum < self.textArray.count) {
        [self textShow];
    }
    else{
        textNum = 0;
        [self textShow];
    }
}

// テキストを登録
-(void)textShow{
    showText_ = [self.textArray objectAtIndex:textNum];
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
                NSLog(@"faaafawefeafaw");
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
            [self jumpPen];
        }
    }
    else{
        //NSLog(@"全文出力");
        [self unschedule:@selector(textUp:)];
    }
    progressTime_ += delta;
}

//---- タッチ処理 ----
// タッチ開始
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL isBlock = NO;
    
    // タッチ座標を、cocos2d座標に変換します
    CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if (CGRectContainsPoint(textWindow_.boundingBox, location)) {
        NSLog(@"NEXT");
        [self nextText];
    }
    else{
        NSLog(@"SKIP");
        isSkip_ = YES;
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
