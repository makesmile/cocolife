//
//  FbEvent.h
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"
#import "Utils.h"
#define FB_EVENT_URL @"http://www.facebook.com/events/"

@interface Event : AbstractModel{
    int coId;
    NSString* owner;
    NSString* category;
    NSString* name;
    NSString* description;
    NSString* image;
    NSString* link;
    NSString* startTime;
    NSString* endTime;
    NSString* updatedTime;
    NSString* location;
    NSString* updated;
    NSString* created;
    NSString* venderId;
    BOOL isNew;
    
    // outer
    NSString* address;
    NSString* station;
    
    NSDate* startDate;
    NSDate* endDate;
}

@property int coId;
@property NSString* owner;
@property NSString* category;
@property NSString* name;
@property NSString* description;
@property NSString* image;
@property NSString* link;
@property NSString* startTime;
@property NSString* endTime;
@property NSString* updatedTime;
@property NSString* location;
@property NSString* updated;
@property NSString* created;
@property NSString* address;
@property NSString* station;
@property NSString* venderId;


-(NSString*) getStartTimeString;
-(NSString*) getEndTimeString;
-(BOOL) isNew;

@end
