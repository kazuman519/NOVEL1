//
//  GameData.h
//  Novel
//
//  Created by 三浦　和真 on 2013/10/23.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameData : CCNode {
    //SQLiteデータベースの名前とパス
    NSString *databaseName_;
}

@property (nonatomic, retain) NSString *databasePath;

//setTextをしていないととれない
@property (nonatomic, retain) NSMutableArray *textArray;
@property (nonatomic, retain) NSMutableArray *charNameArray;
@property (nonatomic, retain) NSMutableArray *inCharArray;
@property (nonatomic, retain) NSMutableArray *outCharArray;
@property (nonatomic, retain) NSMutableArray *changeBgArray;
@property (nonatomic, retain) NSMutableArray *winEfeArray;
@property (nonatomic, retain) NSMutableArray *charGraArray;



+(GameData*)getInstance;

-(void)newData;
-(float)getDay;
-(int)getTime;
-(int)getCharProgressAppointCharID:(int)charID;
-(NSString*)getCharNameAppointID:(int)charID;
-(NSMutableArray*)getAppearanceCharID;
-(void)setTextAppontCharID:(int)charID;
-(void)advanceTime;
-(void)advancePartAppointCharID:(int)charID;
@end
