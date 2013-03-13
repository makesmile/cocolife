//
//  TabBarController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize onChangeTab;

-(id) initWithHeight:(float)height_{
    self = [super init];
    if(self){
        height = height_;
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    [self setOriginalTabButton];
}

// ▼ private ==========================================

-(void) disable{
    for(int i=0,max=[buttons count];i<max;i++){
        ((UIView*)[buttons objectAtIndex:i]).userInteractionEnabled = NO;
    }
}

-(void) enable{
    for(int i=0,max=[buttons count];i<max;i++){
        ((UIView*)[buttons objectAtIndex:i]).userInteractionEnabled = YES;
    }
}

// ▼ public ===========================================

-(void) setOriginalTabButton{
    [self.tabBar removeFromSuperview];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIView* view = self.view;
    
    // ボタンサイズ
    float buttonHeight = 50.25f;
    //    float buttonHeight = 60.0f;
    float buttonWidth = 80.0f;
    // TODO ios6対応
    CGRect buttonFrame = CGRectMake(0, height-buttonHeight, buttonWidth, buttonHeight);
    
    // ボタンセット
    NSMutableArray* tmpButtons = [[NSMutableArray alloc] init];
    for(int i=0;i<4;i++){
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        button.tag = i + 100;
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab0%dOff", i+1]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab0%dOn", i+1]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [tmpButtons addObject:button];
        buttonFrame.origin.x += buttonWidth;
    }
    
    // 影
    UIImageView* shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabShadow"]];
    shadow.tag = 110;
    shadow.userInteractionEnabled = NO;
    shadow.frame = CGRectMake(0, height-buttonHeight-12.0f, 320, 12.5f);
    [view addSubview:shadow];
    
    [[tmpButtons objectAtIndex:0] setSelected:YES];
    buttons = [[NSArray alloc] initWithArray:tmpButtons];
    
    float y = height - buttonHeight;
    [self setTabPosition:y];
}

-(void) setTabPosition:(float)y{
    for(int i=0;i<4;i++){
        UIButton* button = [buttons objectAtIndex:i];
        CGRect currentFrame = button.frame;
        currentFrame.origin.y = y;
        button.frame = currentFrame;
    }
}

-(void) onButtonTap:(UIButton*)target{
    int index = target.tag - 100;
    [self setActiveButton:index];
    self.selectedIndex = index;
    if(onChangeTab)
        onChangeTab(index);
}

-(void) setActiveButton:(int)index{
    for(int i=0,max=[buttons count];i<max;i++){
        [(UIButton*)[buttons objectAtIndex:i] setSelected:NO];
    }
    
    [[buttons objectAtIndex:index] setSelected:YES];
}

// 回転なし
- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation == UIDeviceOrientationPortrait) {
		return YES;
	}
    return NO;
}

@end
