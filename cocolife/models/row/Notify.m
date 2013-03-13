//
//  Notify.m
//  cocosearch
//
//  Created by yu kawase on 13/02/06.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import "Notify.h"

@implementation Notify

@synthesize coId;
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize created;
@synthesize readed;
@synthesize shopName;
@synthesize image;

-(void) setParams:(FMResultSet *)resultSet{
    id_ = [resultSet intForColumn:@"id"];
    coId = [resultSet intForColumn:@"co_id"];
    title = [resultSet stringForColumn:@"title"];
    link = [resultSet stringForColumn:@"link"];
    image = [resultSet stringForColumn:@"image"];
    description = [resultSet stringForColumn:@"description"];
    created = [resultSet intForColumn:@"created"];
    readed = [resultSet intForColumn:@"readed"];
    shopName = [resultSet stringForColumn:@"shopName"];
    createdDate = [NSDate dateWithTimeIntervalSince1970:created];
}

-(BOOL) isReaded{
    return (readed == 1);
}

-(NSString*) createdTimeString{
    return [Utils dateToString:createdDate format:@"yyyy/MM/dd HH:mm"];
}

@end
