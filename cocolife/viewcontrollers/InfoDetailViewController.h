//
//  InfoDetailViewController.h
//  cocosearch
//
//  Created by yu kawase on 12/12/16.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "AbstractCocoViewController.h"
#import "Info.h"
#import "ImageCache.h"
#import "CocoTextView.h"

@interface InfoDetailViewController : AbstractCocoViewController{
    
    // models
    Info* info;
    
    // views
    UIScrollView* sv;
    UIImageView* paperTop;
    UIImageView* paperMiddle;
    UIImageView* paperBottom;
    UIButton* twButton;
    UIButton* fbButton;
    UILabel* naviTitleLabel;
    UILabel* titleLabel;
    UILabel* shopNameLabel;
    UIImageView* imageView;
    CocoTextView* descriptionView;
    UIButton* openButton;
    
    CocoTextView* dateView;
}

-(void) setModel:(Info*)info_;
-(void) update;

@end
