//
//  Notify.h
//  cocosearch
//
//  Created by yu kawase on 13/02/06.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"
#import "Utils.h"

@interface Notify : AbstractModel{
    int coId;
    NSString* title;
    NSString* link;
    NSString* description;
    int created;
    int readed;
    NSDate* createdDate;
    NSString* shopName;
    NSString* image;
}

@property int coId;
@property NSString* title;
@property NSString* link;
@property NSString* description;
@property int created;
@property int readed;
@property NSString* shopName;
@property NSString* image;

-(BOOL) isReaded;
-(NSString*) createdTimeString;

@end
