//
//  NewsView.h
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoList.h"
#import "ImageCache.h"
#import "UIAnimationCommand.h"
#import "SMPageControl.h"

typedef  void (^onTapInfo_t)(Info* info);

@interface InfoSlideCellView : UITableViewCell<
UIScrollViewDelegate
>{
    // delegates
    onTapInfo_t onTapInfo;
    
    // models
    InfoList* infoList;
    
    // views
    UIScrollView* sv;
    SMPageControl *pager;
    UIImageView* newIcon;
    UIView* titleLayer;
    UILabel* titleLabel;
    
    // params
    NSMutableArray* imageViewList;
    NSTimer* scrollTimer;
}

@property (strong) onTapInfo_t onTapInfo;

-(void) assignModel:(InfoList*)infoList_;
-(void) update;

@end
