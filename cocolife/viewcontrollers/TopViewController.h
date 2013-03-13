//
//  TopViewController.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoViewController.h"
#import "EventList.h"
#import "InfoSlideCellView.h"
#import "EventCell.h"

@class TopViewController;

typedef void (^onSelectEvent_t) (AbstractCocoViewController* viewController, Event* event);
typedef void (^onSelectInfo_t) (AbstractCocoViewController* viewController, Info* info);
typedef void (^onLeftToggle_t)();

@interface TopViewController : AbstractCocoViewController<
UITableViewDelegate
, UITableViewDataSource
>{
    // models
    InfoList* infoList;
    EventList* eventList;
    
    // callbacks
    onSelectEvent_t onSelectEvent;
    onLeftToggle_t onLeftToggle;
    onSelectInfo_t onSelectInfo;
    
    // views
    UITableView* tableView_;
    InfoSlideCellView* infoSlide;
}

@property (strong) onSelectEvent_t onSelectEvent;
@property (strong) onSelectInfo_t onSelectInfo;
@property (strong) onLeftToggle_t onLeftToggle;

-(void) assignModel:(InfoList*)infoList_ eventList:(EventList*)eventList_;
-(void) toTop;

@end
