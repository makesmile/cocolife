//
//  EventDetailViewController.h
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "AbstractCocoViewController.h"
#import "Event.h"
#import "CocoH1Label.h"
#import "CocoTextView.h"

@interface EventDetailViewController : AbstractCocoViewController{
    
    // models
    Event* event;
    
    // views
    UIImageView* paperTop;
    UIImageView* paperMiddle;
    UIImageView* paperBottom;
    UIButton* twButton;
    UIButton* fbButton;
    UILabel* naviTitleLabel;
    UILabel* titleLabel;
    UIImageView* imageView;
    UIImageView* imageBgView;
    UIScrollView* sv;
    UILabel* eventTitleLabel;
    UILabel* shopNameLabel;
    UILabel* periodLabel;
    UILabel* accessLabel;
    UIImageView* calenderIcon;
    UIImageView* mapIcon;
    
    CocoTextView* descriptionView;
    UIButton* toKeiroButton;
    UIButton* openButton;
    UIButton* toShopButton;
}

-(void) setModel:(Event*)event_;
-(void) update;

@end
