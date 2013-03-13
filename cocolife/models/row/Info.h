//
//  Info.h
//  cocosearch
//
//  Created by yu kawase on 12/12/16.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"
#import "Utils.h"

@interface Info : AbstractModel{
    int coId;
    NSString* title;
    NSString* description;
    NSString* image;
    NSString* thumbImage;
    NSString* link;
    NSDate* created;
    BOOL isNew;
    
    // outer
    NSString* shopName;
}

@property int coId;
@property NSString* title;
@property NSString* description;
@property NSString* image;
@property NSString* thumbImage;
@property NSString* link;
@property NSDate* created;
@property NSString* shopName;

-(NSString*) getTimeString;
-(BOOL) hasLink;
-(BOOL) isNew;


@end
