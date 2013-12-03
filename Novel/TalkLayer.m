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
    OBJECT_CHAR_LABEL
};

-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        
        [self initValue];
        [self initLayout];
    }
    return self;
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    
    [self textShow:[self.textArray objectAtIndex:0]];
    
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
    maxLineLength_ = 30;
    lineDuring_ = 5;
    fontSize_ = 15.5f;
    delayTime_ = 0.01f;
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
    // テキストウィンドウ
    textWindow_ = [CCSprite spriteWithFile:@"textWindow.jpg"];
    textWindow_.anchorPoint = ccp(0.0, 1.0);
    textWindow_.position = ccp(winSize_.width/2 - textWindow_.contentSize.width/2, textWindow_.contentSize.height);
    [self addChild:textWindow_ z:OBJECT_TEXT_WINDOW tag:OBJECT_TEXT_WINDOW];
    
    // 名前ラベル
    charNameLabel_ = [CCLabelTTF labelWithString:@"unknown" fontName:@"Marker Felt" fontSize:25];
    charNameLabel_.anchorPoint = ccp(0, 0);
    charNameLabel_.position = ccp(textWindow_.position.x, textWindow_.position.y);
    [self addChild:charNameLabel_ z:OBJECT_CHAR_LABEL tag:OBJECT_CHAR_LABEL];
    
    // テキストラベル
    self.labelArray = [NSMutableArray array];
    for (int i = 0; i < maxLineNum_; i++) {
        CCLabelTTF *textLabel = [CCLabelTTF labelWithString:@"feee" fontName:@"Marker Felt" fontSize:fontSize_];
        textLabel.anchorPoint = ccp(0, 1.0);
        textLabel.position = ccp(textWindow_.position.x+10, textWindow_.position.y- 10 - (textLabel.contentSize.height + lineDuring_)*i);
        [self.labelArray addObject:textLabel];
        [self addChild:textLabel z:OBJECT_LINES_LABEL tag:OBJECT_LINES_LABEL];
    }
}

-(void)nextText{
    for (CCLabelTTF* label in self.labelArray){
        label.string = @"";
    }
    isShowText_ = NO;
    isSkip_ = NO;
    
}

/*
 // レイアウト更新
 -(void)updateLayout{
 if ([self.textArray objectAtIndex:part_]) {
 charNameLabel_.string = [self.textArray objectAtIndex:part_];
 [self removeChildByTag:OBJECT_LINES_LABEL];
 [self textShow:[self.textArray objectAtIndex:part_+1]];
 part_+=2;
 }
 }
 */

// テキストを登録
-(void)textShow:(NSString*)text{
    showText_ = text;
    isShowText_ = YES;
    [self schedule:@selector(textUp:)];
}
// テキストを１文字づつ、もしくは一括で表示する
-(void)textUp:(ccTime)delta{
    if (nowTextLength_ < showText_.length && isShowText_) {
        NSLog(@"%d:%d",nowTextLength_,showText_.length);
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
        isSkip_ = YES;
    }
    else{
        NSLog(@"NEXT");
        
        // 次の生き方
        [self nextText];
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
