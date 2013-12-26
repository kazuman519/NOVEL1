//
//  GameData.m
//  Novel
//
//  Created by 三浦　和真 on 2013/10/23.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "GameData.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation GameData

static GameData* _gameDataInstance = nil;

+ (GameData*)getInstance{
    if (_gameDataInstance != nil) {
        return _gameDataInstance;
    }else{
        _gameDataInstance = [[GameData alloc] init];
        return _gameDataInstance;
    }
}

-(id)init{
    if (self=[super init]) {
        // 初期化
        self.textArray = [NSMutableArray array];
        self.charNameArray = [NSMutableArray array];
        self.inCharArray = [NSMutableArray array];
        self.outCharArray= [NSMutableArray array];
        self.changeBgArray = [NSMutableArray array];
        self.winEfeArray = [NSMutableArray array];
        self.seArray = [NSMutableArray array];
        self.charGraArray = [NSMutableArray array];
        self.charEfeArray = [NSMutableArray array];
        
        //データベースの選択
        databaseName_ = @"novelDB.sqlite";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        self.databasePath = [documentDir stringByAppendingPathComponent:databaseName_];
        
        [self createAndCheckDatabase];
        [self selectDB];
    }
    return self;
}

// ------ データベース関連 -----
-(void) createAndCheckDatabase {
    
    BOOL success;
    
    //databasePathにデータベースファイルがあるか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.databasePath];
    
    //もしあれば、処理中断
    if(success){
        //NSLog(@"あったああ%@",self.databasePath);
        return;
    }
    
    //プロジェクトフォルダからサンドボックスへコピー
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName_];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
}

// データベース内のデータを参照する
-(void)selectDB {
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM user"];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    while([rs next]) {
        NSLog(@"%f",[rs doubleForColumn:@"progressDay"]);
    }
    //Databaseを閉じる
    [db close];
}

-(void)newData{
    float progressDay = 1.1;
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *update_query = [NSString stringWithFormat:@"UPDATE user SET progressDay = %f",progressDay];
    //クエリ開始
    [db beginTransaction];
    //クエリ実行
    [db executeUpdate:update_query];
    //Databaseへの変更確定
    [db commit];
    
    update_query = @"UPDATE archive set progressNum = 1,completionNum = 1";
    [db beginTransaction];
    [db executeUpdate:update_query];
    [db commit];
    
    //Databaseを閉じる
    [db close];
}

-(float)getDay{
    float progressDay;
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM user"];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    while([rs next]) {
        progressDay = [rs doubleForColumn:@"progressDay"];
    }
    //Databaseを閉じる
    [db close];
    
    return progressDay;
}
-(int)getTime{
    float day = [self getDay];
    int time = (int)(day * 10) % 10;
    
    return time;
}
-(int)getCharProgressAppointCharID:(int)charID{
    float progressNum;
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM archive WHERE charID = %d",charID];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    while([rs next]) {
        progressNum = [rs doubleForColumn:@"progressNum"];
    }
    //Databaseを閉じる
    [db close];
    
    return progressNum;
}
-(NSString *)getCharNameAppointID:(int)charID{
    NSString* charName;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM character WHERE id = %d",charID];
    [db beginTransaction];
    FMResultSet *rs = [db executeQuery:select_query];
    while([rs next]) {
        charName = [rs stringForColumn:@"name"];
    }
    [db close];
    
    return charName;
}
-(NSMutableArray *)getAppearanceCharID{
    NSMutableArray* idArray = [NSMutableArray array];
    float progressDay = [self getDay];
    int   charNum;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM appearance WHERE day = %f",progressDay];
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    charNum = rs.columnCount-1; // カラムの数でキャラクター数を特定
    while([rs next]) {
        for (int charID = 1; charID <= charNum; charID++) {
            NSString *columnName = [NSString stringWithFormat:@"id%d",charID];
            if ([rs intForColumn:columnName] == 1) {
                [idArray addObject:[NSNumber numberWithInt:charID]];
            }
        }
    }
    //Databaseを閉じる
    [db close];
    
    return idArray;
}
-(void)setTextAppontCharID:(int)charID{
    [self.textArray removeAllObjects];
    [self.charNameArray removeAllObjects];
    [self.inCharArray removeAllObjects];
    [self.outCharArray removeAllObjects];
    [self.changeBgArray removeAllObjects];
    [self.winEfeArray removeAllObjects];
    [self.seArray removeAllObjects];
    [self.charGraArray removeAllObjects];
    [self.charEfeArray removeAllObjects];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    //クエリ文を指定
    NSString *select_query = [NSString stringWithFormat:@"SELECT * FROM story%d WHERE part = %d",charID,[self getCharProgressAppointCharID:charID]];
    if (charID==0) {
        select_query = [NSString stringWithFormat:@"SELECT * FROM story%d",charID];
    }
    [db beginTransaction];
    
    FMResultSet *rs = [db executeQuery:select_query];
    while([rs next]) {
        [self.textArray addObject:[rs stringForColumn:@"text"]];
        NSString* name = [rs stringForColumn:@"name"];
        if (name == Nil) {
            NSLog(nil);
            name = @" ";
        }else{
            name = [rs stringForColumn:@"name"];
        }
        [self.charNameArray addObject:name];
        [self.inCharArray addObject:[NSNumber numberWithFloat:[rs doubleForColumn:@"inChar"]]];
        [self.outCharArray addObject:[NSNumber numberWithFloat:[rs doubleForColumn:@"outChar"]]];
        [self.changeBgArray addObject:[NSNumber numberWithInteger:[rs intForColumn:@"changeBg"]]];
        [self.winEfeArray addObject:[NSNumber numberWithInteger:[rs intForColumn:@"winEfe"]]];
        [self.seArray addObject:[NSNumber numberWithInteger:[rs intForColumn:@"SE"]]];
        [self.charGraArray addObject:[NSNumber numberWithFloat:[rs doubleForColumn:@"charGra"]]];
        [self.charEfeArray addObject:[NSNumber numberWithFloat:[rs doubleForColumn:@"charEffect"]]];
    }
    //Databaseを閉じる
    [db close];
}
-(void)advanceTime{
    [self getAppearanceCharID];
    float day = [self getDay];
    float nextTime;
    int check = (int)(day * 10) % 10;
    if (check == 3) {
        nextTime = (int)day + 1.1;
    }
    else{
        nextTime = day + 0.1;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *update_query = [NSString stringWithFormat:@"UPDATE user SET progressDay = %f",nextTime];
    //クエリ開始
    [db beginTransaction];
    //クエリ実行
    [db executeUpdate:update_query];
    //Databaseへの変更確定
    [db commit];
    
    //Databaseを閉じる
    [db close];
}
-(void)advancePartAppointCharID:(int)charID{
    int progressNum = [self getCharProgressAppointCharID:charID];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    //クエリ文を指定
    NSString *update_query = [NSString stringWithFormat:@"UPDATE archive SET progressNum = %d WHERE charID = %d",progressNum+1,charID];
    //クエリ開始
    [db beginTransaction];
    //クエリ実行
    [db executeUpdate:update_query];
    //Databaseへの変更確定
    [db commit];
    
    //Databaseを閉じる
    [db close];
}
@end
