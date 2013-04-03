//
//  EventFeedView.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventFeedViewRow.h"
#import "CocoH1Label.h"

typedef void (^openTalk_t)(float height);

@interface EventFeedView : UIView{
    // models
    FbEventUserList* userList;
    
    // params
    NSMutableArray* rowList;
    CGRect originalFrame;
    
    // views
    EventFeedViewRow* currentRow;
    UIActivityIndicatorView* indicator;
    
    // callbacks
    openTalk_t openTalk;
}

@property CGRect originalFrame;
@property (strong) openTalk_t openTalk;

-(void) reset;
-(void) setModel:(FbEventUserList*)userList_;
-(void) update;
-(void) hide;
-(void) show;

@end
