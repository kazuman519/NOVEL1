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
@property (nonatomic, retain) NSMutableArray *textArray;
@property (nonatomic, retain) NSMutableArray *charNameArray;

+(GameData*)getInstance;

-(void)newData;
-(float)getDay;
-(int)getTime;
-(NSString*)getCharNameAppointID:(int)charID;
-(NSMutableArray*)getAppearanceCharName;
-(void)nextTime;
@end
