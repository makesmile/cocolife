//
//  Coco.m
//  cocosearch
//
//  Created by yu kawase on 12/12/09.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "Coco.h"

@implementation Coco

@synthesize name;
@synthesize excerpt;
@synthesize description;
@synthesize hour;
@synthesize price;
@synthesize station;
@synthesize address;
@synthesize tel;
@synthesize url;
@synthesize twitter;
@synthesize facebook;
@synthesize lat;
@synthesize lng;
@synthesize created;
@synthesize image;
@synthesize thumbImage;
@synthesize favorit;

-(void) setParams:(FMResultSet *)resultSet{
    name = [resultSet stringForColumn:@"name"];
    excerpt = [resultSet stringForColumn:@"excerpt"];
    if(excerpt == nil){
        excerpt = @"";
    }
    description = [resultSet stringForColumn:@"description"];
    hour = [resultSet stringForColumn:@"hour"];
    price = [resultSet stringForColumn:@"price"];
    station = [resultSet stringForColumn:@"station"];
    address = [resultSet stringForColumn:@"address"];
    tel = [resultSet stringForColumn:@"tel"];
    url = [resultSet stringForColumn:@"url"];
    twitter = [resultSet stringForColumn:@"twitter"];
    facebook = [resultSet stringForColumn:@"facebook"];
    lat = [resultSet doubleForColumn:@"lat"];
    lng = [resultSet doubleForColumn:@"lng"];
    created = [resultSet stringForColumn:@"created"];
    image = [resultSet stringForColumn:@"image"];
    thumbImage = [resultSet stringForColumn:@"thumb_image"];
    favorit = [resultSet intForColumn:@"favorit"];
    isNew = ([resultSet intForColumn:@"new"] == 1);
}

-(void) setDetailList:(NSArray*)detailList_{
    detailList = detailList_;
}

-(NSArray*) getDetailList{
    return detailList;
}

-(BOOL) isFavorit{
    return (favorit == 1);
}

-(void) toFavorit{
    favorit = 1;
}

-(void) noFavorit{
    favorit = 0;
}

-(BOOL) isNew{
    return isNew;
}

@end
