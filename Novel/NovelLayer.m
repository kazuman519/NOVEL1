//
//  NovelLayer.m
//  Novel
//
//  Created by 三浦　和真 on 2013/10/22.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "NovelLayer.h"


@implementation NovelLayer
enum {
    OBJECT_NULL,
    OBJECT_CHARACTER,
    OBJECT_TEXT_WINDOW,
    OBJECT_LINES_LABEL
};

-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        // 初期値
        part_ = 0;
        textLength_ = 30;
        lineNum_ = 3;
        fontSize_ = 10.5;
        lineDuring_ = 15;
        delayTime_ = 0.5;
        
        self.textArray = [NSMutableArray array];
        
        // test
        progressTime_ = 0.0;
        showStringNum_ = 0;
        isSkip_ = NO;
        showTexttt_ = [NSString string];
        
        [self initLayout];
    }
    return self;
}

-(void)test{
    [self te:@"あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみみむめもやいゆえよらりるれろわをん"];
}

-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    
    if (self.textArray.count > 0) {
        //NSString *showText = [self.textArray objectAtIndex:0];
        //[self textShow:showText];
    }
    else{
        NSLog(@"表示するテキストがこのパートにはありません");
    }
    [self test];
    
    // CCTouchDispatcherに登録します（initメソッド内でコールしても機能しません。）
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(void) onExit
{
	// CCTouchDispatcherから登録を削除します
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	
	// 忘れずにスーパークラスのonExitをコールします
	[super onExit];
}

// レイアウト初期化
-(void)initLayout{
    // テキストウィンドウ
    textWindow_ = [CCSprite spriteWithFile:@"textWindow.jpg"];
    textWindow_.anchorPoint = ccp(0.0, 1.0);
    textWindow_.position = ccp(0, textWindow_.contentSize.height);
    [self addChild:textWindow_ z:OBJECT_TEXT_WINDOW tag:OBJECT_TEXT_WINDOW];
    
    // キャラクター画像
    charSprite_ = [CCSprite spriteWithFile:@"おれ.jpg"];
    charSprite_.anchorPoint = ccp(0, 0);
    charSprite_.position = ccp(0, 0);
    //[self addChild:charSprite_ z:OBJECT_CHARACTER tag:OBJECT_CHARACTER];
    
    // 名前ラベル
    charNameLabel_ = [CCLabelTTF labelWithString:@"unknown" fontName:@"Marker Felt" fontSize:25];
    charNameLabel_.anchorPoint = ccp(0, 0);
    charNameLabel_.position = ccp(textWindow_.position.x, textWindow_.position.y);
    [self addChild:charNameLabel_];
    
    // キャラクターのポジション
    reftPosition_ = ccp(0, 60);
    lightPositon_ = ccp(winSize_.width - charSprite_.contentSize.width, 60);
    
    // キャラポジチェンジ
    charSprite_.position = lightPositon_;
    
    // ららばえらじぇおふぁ
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Novel" fontName:@"Marker Felt" fontSize:40];
    label.anchorPoint = ccp(0.5, 1.0);
    label.position = ccp(winSize_.width/2, winSize_.height);
    [self addChild:label];
    
    
    // uhihiu
    self.labelArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        CCLabelTTF *textLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:fontSize_];
        textLabel.anchorPoint = ccp(0, 1.0);
        textLabel.position = ccp(textWindow_.position.x+10, textWindow_.position.y-10 - (textLabel.contentSize.height + lineDuring_)*i);
        [self.labelArray addObject:textLabel];
        [self addChild:textLabel z:OBJECT_LINES_LABEL tag:OBJECT_LINES_LABEL];
    }
}

// レイアウト更新
-(void)updateLayout{
    if ([self.textArray objectAtIndex:part_]) {
        charNameLabel_.string = [self.textArray objectAtIndex:part_];
        [self removeChildByTag:OBJECT_LINES_LABEL];
        [self textShow:[self.textArray objectAtIndex:part_+1]];
        part_+=2;
    }
}

-(void)textShow:(NSString*)text{
    NSString *showText = [NSString string];
    int length = text.length;

    for (int i = 0; length>0; i++,length-=textLength_) {
        if (length < textLength_) {
            showText = [text substringWithRange:NSMakeRange(textLength_*i, length)];
        }
        else{
            showText = [text substringWithRange:NSMakeRange(textLength_*i, textLength_)];
        }
        [self ScriptReader:showText number:i];
    }

    // もし規定表示文字数以上だったらログをだす
    if (text.length > textLength_ * lineNum_) {
        NSLog(@"規定表示文字数オーバーです！！ [%d文字]",text.length);
    }
}

// test
-(void)te:(NSString*)text{
    NSString *addText = [text substringWithRange:NSMakeRange(30, 1)];
    NSLog(@"%@",addText);
    
    showTexttt_ = text;
    [self schedule:@selector(sho:)];
}
-(void)sho:(ccTime)delta{
    progressTime_ += delta;
    if (showStringNum_ < showTexttt_.length) {
        if (isSkip_) {
            showStringNum_ = showTexttt_.length;
            NSLog(@"feaw:%d",showStringNum_/textLength_);
            for (int i = 0; i <= showStringNum_/textLength_; i++) {
                CCLabelTTF *label = [self.labelArray objectAtIndex:i];
                if (i==showStringNum_/textLength_) {
                    label.string = [showTexttt_ substringWithRange:NSMakeRange(i*textLength_, showStringNum_-textLength_*i)];
                }
                else{
                    label.string = [showTexttt_ substringWithRange:NSMakeRange(i*textLength_, textLength_)];
                }
                NSLog(@"%d",i);
            }
        }
        else if (progressTime_ >= delayTime_) {
            progressTime_=0.0;
            showStringNum_++;
            int lineNum = showStringNum_/(textLength_+1);
            CCLabelTTF* label = [self.labelArray objectAtIndex:lineNum];
            label.string = [showTexttt_ substringWithRange:NSMakeRange(lineNum * textLength_, showStringNum_ - lineNum * 30) ];
            //NSLog(@"%d:%d",showStringNum_,lineNum);
        }
    }
    else{
        //NSLog(@"全文出力");
    }
}

//scriptに入った文字列が一文字ずつ表示される。１行につき①ラベル
-(void)ScriptReader:(NSString *)script number:(int)number{
    //　送られてきたナンバーによって座標決定
    CCLabelTTF *textLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:fontSize_];
    textLabel.anchorPoint = ccp(0, 1.0);
    textLabel.position = ccp(textWindow_.position.x+10, textWindow_.position.y-10 - (textLabel.contentSize.height + lineDuring_)*number);
    [self addChild:textLabel z:OBJECT_LINES_LABEL tag:OBJECT_LINES_LABEL];
    
    for (int i=0; i < script.length; i++) {
        NSString *tmp_str = [script substringWithRange:NSMakeRange(i, 1)];
        
        id delay = [CCDelayTime actionWithDuration:delayTime_*(i+1) + delayTime_*textLength_*number];
        id block = [CCCallBlock actionWithBlock:^{
            NSString *string = [textLabel.string stringByAppendingString:tmp_str];
            [textLabel setString:string];
        }];
        [self runAction:[CCSequence actions:delay, block, nil]];
    }
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
        //[self updateLayout];
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
