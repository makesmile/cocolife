//
//  Info.m
//  cocosearch
//
//  Created by yu kawase on 12/12/16.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "Info.h"

@implementation Info

@synthesize coId;
@synthesize title;
@synthesize description;
@synthesize image;
@synthesize thumbImage;
@synthesize link;
@synthesize created;
@synthesize shopName;

-(void) setParams:(FMResultSet *)resultSet{
    id_ = [resultSet intForColumn:@"id"];
    coId = [resultSet intForColumn:@"co_id"];
    title = [resultSet stringForColumn:@"title"];
    description = [resultSet stringForColumn:@"description"];
    link = [resultSet stringForColumn:@"link"];
    thumbImage = [resultSet stringForColumn:@"thumb_image"];
    image = [resultSet stringForColumn:@"image"];
    created = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"created"]];
    isNew = ([resultSet intForColumn:@"new"] == 1);
    shopName = [resultSet stringForColumn:@"shopName"];
    if(shopName == nil){
        shopName = @"cocolife";
    }
}

-(NSString*) getTimeString{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:[NSString stringWithFormat:@"MM月dd日(%@)", [Utils getShortWeekString:created]]];
    
    return [outputFormatter stringFromDate:created];
}

-(BOOL)hasLink{
    return (![link isEqualToString:@""]);
}

-(BOOL) isNew{
    return isNew;
}

@end
