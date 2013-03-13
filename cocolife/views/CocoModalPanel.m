//
//  CocoModalPanel.m
//  cocolife
//
//  Created by yu kawase on 13/03/13.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "CocoModalPanel.h"

@implementation CocoModalPanel

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    self.autoresizingMask =
    UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.autoresizesSubviews = YES;
//    self.margin = UIEdgeInsetsMake(30, 15, 100, 5);
    self.shouldBounce = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
