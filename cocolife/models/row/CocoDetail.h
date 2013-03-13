//
//  CocoDetail.h
//  cocosearch
//
//  Created by yu kawase on 12/12/10.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractModel.h"

@interface CocoDetail : AbstractModel{
    NSString* title;
    NSString* description;
    NSString* image;
}

@property NSString* title;
@property NSString* description;
@property NSString* image;

@end
