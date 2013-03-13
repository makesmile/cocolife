//
//  CocoH1Label.m
//  cocosearch
//
//  Created by yu kawase on 13/01/20.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import "CocoH1Label.h"

@implementation CocoH1Label

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    self.frame = CGRectMake(30, 0, 260, 30);
    self.textColor = UIColorFromHex(0x885731);
    self.numberOfLines = 1;
    self.font = [UIFont boldSystemFontOfSize:14.0f];
    self.backgroundColor = [UIColor clearColor];
}


// ▼ public ================================

-(float) updatePositionY:(float)y{
    CGRect myFrame = self.frame;
    myFrame.origin.y = y;
    self.frame = myFrame;
    return y+myFrame.size.height;
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
