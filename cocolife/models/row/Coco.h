//
//  Coco.h
//  cocosearch
//
//  Created by yu kawase on 12/12/09.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"
#import "CocoDetail.h"

@interface Coco : AbstractModel{
    NSString* name;
    NSString* excerpt;
    NSString* description;
    NSString* hour;
    NSString* price;
    NSString* station;
    NSString* address;
    NSString* tel;
    NSString* url;
    NSString* twitter;
    NSString* facebook;
    double lat;
    double lng;
    NSString* created;
    NSString* image;
    NSString* thumbImage;
    BOOL isNew;
    
    NSArray* detailList;
}

@property NSString* name;
@property NSString* excerpt;
@property NSString* description;
@property NSString* hour;
@property NSString* price;
@property NSString* station;
@property NSString* address;
@property NSString* tel;
@property NSString* url;
@property NSString* twitter;
@property NSString* facebook;
@property NSString* created;
@property NSString* image;
@property NSString* thumbImage;
@property double lat;
@property double lng;
@property int favorit;

-(void) setDetailList:(NSArray*)detailList_;
-(NSArray*) getDetailList;
-(BOOL) isFavorit;
-(void) toFavorit;
-(BOOL) isNew;

@end
