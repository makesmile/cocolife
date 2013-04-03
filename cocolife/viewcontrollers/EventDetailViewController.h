//
//  EventDetailViewController.h
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "AbstractCocoViewController.h"

// view
#import "CocoH1Label.h"
#import "CocoTextView.h"
#import "EventFeedView.h"

// models
#import "Event.h"
#import "FbEventUserList.h"

// command
#import "FbEventFeedComand.h"

@interface EventDetailViewController : AbstractCocoViewController{
    
    // models
    Event* event;
    
    // views
    UIImageView* paperTop;
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
    UIImageView* lineView;
    UIImageView* eventLineView;
    CocoH1Label* feedTitleLabel;
    
    CocoTextView* descriptionView;
    UIButton* toKeiroButton;
    UIButton* openButton;
    UIButton* toShopButton;
    EventFeedView* eventFeedView;
    UIActivityIndicatorView* indicator;
    
    float originalHeight;
}

-(void) setModel:(Event*)event_;
-(void) update;

@end
