//
//  EventFeedView.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "EventFeedView.h"

@implementation EventFeedView

@synthesize openTalk;
@synthesize originalFrame;

-(id)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    currentRow = nil;
    rowList = [[NSMutableArray alloc] init];
}

-(void) reset{
    currentRow = nil;
    for(int i=0,max=[rowList count];i<max;i++){
        [((EventFeedViewRow*) [rowList objectAtIndex:i]) removeFromSuperview];
    }
    [rowList removeAllObjects];
}

-(void) setModel:(FbEventUserList*)userList_{
    static int ROW_UNIT_NUM = 4;
    
    userList = userList_;
    int count = [userList count];
    int rowNum = (count / ROW_UNIT_NUM) + 1;
    if(count == 0 || count%ROW_UNIT_NUM == 0){
        rowNum--;
    }
    
    CGRect rowFrame = CGRectMake(0, 0, 280, 58);
    float margin = 10;
    
    openRow_t openRow = ^(EventFeedViewRow* row, float height){
        int index = row.tag;
        float sa = (currentRow == nil) ? 0 : [currentRow talkHeight];
        if(currentRow.tag == row.tag){
            sa = 0;
        }else{
            [currentRow reset];
        }
        
        if(openTalk)
            openTalk(height);
        
        CGRect toFrame = originalFrame;
        toFrame.size.height += height;
        self.frame = toFrame;
        
        currentRow = row;
        [UIView animateWithDuration:0.3f animations:^{
            for(int i=0,max=[rowList count];i<max;i++){
                if(i <= index){
                    EventFeedViewRow* rowView = (EventFeedViewRow*)[rowList objectAtIndex:i];
                    CGRect currentFrame = rowView.originalFrame;
                    rowView.frame = currentFrame;
                }else{
                    EventFeedViewRow* rowView = (EventFeedViewRow*)[rowList objectAtIndex:i];
                    CGRect currentFrame = rowView.originalFrame;
                    currentFrame.origin.y += height;
                    rowView.frame = currentFrame;
                }
            }
        }];
    };
    
    for(int i=0;i<rowNum;i++){
        EventFeedViewRow* rowView = [[EventFeedViewRow alloc] init];
        [rowView setModel:userList offset:(i*ROW_UNIT_NUM)];
        rowView.frame = rowFrame;
        rowView.originalFrame = rowFrame;
        rowFrame.origin.y += rowFrame.size.height + margin;
        rowView.tag = i;
        rowView.openRow = openRow;
        [self addSubview:rowView];
        [rowList addObject:rowView];
    }
}

-(void) update{
    for(int i=0,max=[rowList count];i<max;i++){
        EventFeedViewRow* rowView = [rowList objectAtIndex:i];
        [rowView update];
    }
    
    self.frame = CGRectMake(20, 100, 280, [rowList count]*(58+10) + 20/*title*/);
    self.backgroundColor = UIColorFromHex(0xfcedd6);
}

-(void) hide{
    self.alpha = 0;
    self.hidden = YES;
}

-(void) show{
    self.hidden = NO;
    CGRect originalFrame = self.frame;
    CGRect currentFrame = originalFrame;
    currentFrame.origin.y += 10;
    self.frame = currentFrame;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = originalFrame;
        self.alpha = 1.0f;
    }];
}




@end
