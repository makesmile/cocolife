//
//  TabBarController.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onChangeTab_t)(int index);

@interface TabBarController : UITabBarController{
    // callbacks
    onChangeTab_t onChangeTab;
    
    NSArray* buttons;
    float height;
}

@property (strong) onChangeTab_t onChangeTab;

-(id) initWithHeight:(float)height_;
-(void) setActiveButton:(int)index;

@end