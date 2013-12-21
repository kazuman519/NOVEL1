//
//  MenuScene.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/28.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "ActionSelectLayer.h"
#import "CharSelectLayer.h"
#import "ItemLayer.h"
#import "DataLayer.h"
#import "ShopLayer.h"
#import "SystemLayer.h"


@interface MenuScene : CCLayer {
    CGSize winSize_;
    
    ActionSelectLayer*  actionSelectLayer_;
    CharSelectLayer*    charSelectLayer_;
    ItemLayer*          itemLayer_;
    DataLayer*          dataLayer_;
    ShopLayer*          shopLayer_;
    SystemLayer*        systemLayer_;
}

@end
