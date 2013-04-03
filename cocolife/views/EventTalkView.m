//
//  EventTalkView.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "EventTalkView.h"

@implementation EventTalkView

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    self.clipsToBounds = YES;
    hukidasiList = [[NSMutableArray alloc] init];
    
    stage = [[UIView alloc] init];
    stage.frame = CGRectMake(0, 9, 280, 0);
    stage.backgroundColor = UIColorFromHex(0xf2dcbb);
    [self addSubview:stage];
    
    hukidasiArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hukidasiArrow"]];
    hukidasiArrow.frame = CGRectMake(0, 0, 19.5f, 10);
    [self addSubview:hukidasiArrow];
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailLine"]];
    [stage addSubview:lineImageView];
}

-(void) reset{
    for(int i=0,max=[hukidasiList count];i<max;i++){
        UserHukidasi* hukidasi = (UserHukidasi*)[hukidasiList objectAtIndex:i];
        [hukidasi removeFromSuperview];
    }
    
    [hukidasiList removeAllObjects];
    self.frame = CGRectMake(0, 60 + 10, 280, 0);
}

-(void) setModel:(FbEventUser*)user_{
    [self reset];
    user = user_;
}

-(void) update{
    float currentY = 0;
    FbEventUserList* commentList = [user getCommentList];
    
    UserHukidasi* hukidasi = [[UserHukidasi alloc] init];
    [hukidasi setModel:user index:1];
    [hukidasi update];
    [stage addSubview:hukidasi];
    [hukidasiList addObject:hukidasi];
    currentY = [hukidasi setY:currentY];
    for(int i=0,max=[commentList count];i<max;i++){
        FbEventUser* commentUser = (FbEventUser*)[commentList get:i];
        UserHukidasi* hukidasi = [[UserHukidasi alloc] init];
        [hukidasi setModel:commentUser index:i];
        [hukidasi update];
        
        [hukidasiList addObject:hukidasi];
        currentY = [hukidasi setY:currentY];
        [stage addSubview:hukidasi];
    }
    
    currentY += 20;
    stage.frame = CGRectMake(0, 9, 280, currentY);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 60 + 10, 280, currentY);
    }];
    
}

-(void) arrowX:(float)x{
    hukidasiArrow.frame = CGRectMake(x, 0, 19.5f, 10);
}


@end
