//
//  SystemLayer.h
//  Novel
//
//  Created by 三浦　和真 on 2013/11/27.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface SystemLayer : CCLayer {
    CGSize winSize_;
    
    CCLabelTTF* titleLabel_;
    CCMenuItemFont* returnBtn_;
    CCMenuItemFont* returnTitleBtn_;
    
    CGPoint titleLabelPos_;
    CGPoint returnBtnPos_;
    CGPoint returnTitleBtnPos_;
}

@property BOOL isReturn;

-(void)showAction;
-(void)hideAction;
@end
