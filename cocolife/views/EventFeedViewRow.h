//
//  EventFeedViewRow.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ImageCache.h"
#import "FbEventUserList.h"
#import "EventTalkView.h"

@class EventFeedViewRow;

typedef void (^onTapUser_t)(UIView* view, FbEventUser* user);

@interface EventFeedImage :UIView{
    // view
    UIButton* imageButton;
    UIActivityIndicatorView* indicator;
    UIImageView* hukidasiView;
    
    // models
    FbEventUser* user;
    
    // callbacks
    onTapUser_t onTapUser;
}

@property (strong) onTapUser_t onTapUser;

-(void) setModel:(FbEventUser*)user_;
-(void) update;
-(void) hide;

@end


typedef void (^openRow_t)(EventFeedViewRow* viewRow, float height);

@interface EventFeedViewRow : UIView{
    // models
    FbEventUserList* userList;
    
    // params
    int offset;
    NSMutableArray* viewList;
    CGRect originalFrame;
    
    // views
    EventTalkView* eventTalkView;
    
    // callback
    openRow_t openRow;
}

@property CGRect originalFrame;
@property (strong) openRow_t openRow;

-(void) setModel:(FbEventUserList*)userList_ offset:(int)offset_;
-(void) update;
-(float) talkHeight;
-(void) reset;

@end
