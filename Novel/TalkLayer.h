//
//  TalkLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"

@interface TalkLayer : CCLayer {
    CGSize winSize_;
    CGPoint zeroPos_;
    GameData* gameData_;
    
    CCSprite* bgSprite_;
    CCMenuItemSprite* menuBtn_;
    CCSprite* textWindow_;
    CCSprite* penSprite_;
    CCLabelTTF* charNameLabel_;
    CGPoint penPos_;
    
    // 設定関連
    int maxLineNum_;    //１行の最大文字数
    int maxLineLength_; //最大行数
    int nowTextLength_; //現在表示しているテキストの長さ
    int lineDuring_;    //行の間隔
    int fontSize_;      //文字サイズ
    float delayTime_;   //文字の表示スピード
    float progressTime_;//現在表示にかかっている時間
    NSString *showText_;//現在表示させているテキスト
    
    BOOL isShowText_;   //テキストが表示されきったかの確認
    BOOL isSkip_;       //スキップがされたかの確認
    
    // なんか
    int textNum;        //現在表示させたテキストのナンバー
}

@property (nonatomic,retain)NSMutableArray* textArray;
@property (nonatomic,retain)NSMutableArray* nameArray;
@property (nonatomic,retain)NSMutableArray* inCharArray;
@property (nonatomic,retain)NSMutableArray* outCharArray;
@property (nonatomic,retain)NSMutableArray* labelArray;
@property (nonatomic,retain)NSMutableArray* charArray;
@property (nonatomic,retain)NSMutableArray* charIDArray;
@property (nonatomic,retain)NSMutableArray* charPosArray;
@end
