//
//  FbEvent.m
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize coId;
@synthesize owner;
@synthesize category;
@synthesize name;
@synthesize description;
@synthesize image;
@synthesize link;
@synthesize startTime;
@synthesize endTime;
@synthesize updatedTime;
@synthesize location;
@synthesize updated;
@synthesize created;
@synthesize address;
@synthesize station;

-(void) setParams:(FMResultSet *)resultSet{
    coId = [resultSet intForColumn:@"co_id"];
    owner = [resultSet stringForColumn:@"owner"];
    category = [resultSet stringForColumn:@"category"];
    name = [resultSet stringForColumn:@"name"];
    description = [resultSet stringForColumn:@"description"];
    image = [resultSet stringForColumn:@"image"];
    link = [resultSet stringForColumn:@"link"];
    startTime = [resultSet stringForColumn:@"start_time"];
    endTime = [resultSet stringForColumn:@"end_time"];
    updatedTime = [resultSet stringForColumn:@"updated_time"];
    location = [resultSet stringForColumn:@"location"];
    updated = [resultSet stringForColumn:@"updated"];
    created = [resultSet stringForColumn:@"created"];
    isNew = ([resultSet intForColumn:@"new"] == 1);
    address = [resultSet stringForColumn:@"address"];
    station = [resultSet stringForColumn:@"station"];
    
    startDate = [Utils stringToDate:self.startTime format:@"yyyy-MM-dd'T'HH:mm:ss"];
    endDate = [Utils stringToDate:self.endTime format:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSTimeInterval addDay = 9*60*60; // 9時間進める
    startDate = [NSDate dateWithTimeInterval:addDay sinceDate:startDate];
    endDate = [NSDate dateWithTimeInterval:addDay sinceDate:endDate];
}

-(NSString*) getStartTimeString{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:[NSString stringWithFormat:@"MM月dd日(%@)", [Utils getShortWeekString:startDate]]];
    
    return [outputFormatter stringFromDate:startDate];
}

-(NSString*) getEndTimeString{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:[NSString stringWithFormat:@"MM月dd日(%@)", [Utils getShortWeekString:endDate]]];
    
    return [outputFormatter stringFromDate:endDate];
}


-(BOOL) isNew{
    return isNew;
}

@end
