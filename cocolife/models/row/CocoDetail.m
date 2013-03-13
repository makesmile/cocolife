//
//  CocoDetail.m
//  cocosearch
//
//  Created by yu kawase on 12/12/10.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "CocoDetail.h"

@implementation CocoDetail

@synthesize title;
@synthesize description;
@synthesize image;

-(void)setParams:(FMResultSet *)resultSet {
    title = [resultSet stringForColumn:@"title"];
    description = [resultSet stringForColumn:@"description"];
    image = [resultSet stringForColumn:@"image"];
}

@end
