//
//  EventTalkView.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbEventUser.h"
#import "FbEventUserList.h"
#import "Utils.h"
#import "UserHukidasi.h"

@interface EventTalkView : UIView{
    // models
    FbEventUser* user;
    
    // views
    UIImageView* hukidasiArrow;
    UIView* stage;
    NSMutableArray* hukidasiList;
}

-(void) reset;
-(void) setModel:(FbEventUser*)user_;
-(void) update;
-(void) arrowX:(float)x;

@end
