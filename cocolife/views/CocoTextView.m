//
//  CocoTextView.m
//  cocosearch
//
//  Created by yu kawase on 13/01/20.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import "CocoTextView.h"

@interface UITextView ()
- (id)styleString; // make compiler happy
@end

@implementation CocoTextView

- (id)styleString {
    return [[super styleString] stringByAppendingString:@"; line-height: 1.3em"];
}

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    self.frame = CGRectMake(25, 0, 270, 1000);
    self.textColor = UIColorFromHex(0x885731);
    self.font = [UIFont systemFontOfSize:12.0f];
    self.backgroundColor = [UIColor clearColor];
    self.editable = NO;
}

-(float) updatePositionY:(float)y{
    CGRect myFrame = self.frame;
    myFrame.origin.y = y;
    myFrame.size.height = self.contentSize.height;
    
    self.frame = myFrame;
    return y + myFrame.size.height;
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
