//
//  UserHukidasi.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbEventUser.h"
#import "ImageCache.h"

@interface UserHukidasi : UIView{
    // models
    FbEventUser* user;
    
    // params
    int index;
    
    // views
    UIImageView* imageView;
    UILabel* nameLabel;
    UITextView* messageView;
    UIImageView* messageBg;
}

-(void) setModel:(FbEventUser*)user_ index:(int)index_;
-(void) update;
-(float) setY:(float)y;

@end
