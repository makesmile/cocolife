//
//  EventCell.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ImageCache.h"

@interface EventCell : UITableViewCell{
    Event* event;
    
    UIImageView* calIcon;
    UIImageView* pinIcon;
    UIImageView* newIcon;
    
    UIImageView* imageView;
    
    UILabel* name;
    UILabel* period;
    UILabel* access;
    UILabel* excerpt;
    UIActivityIndicatorView* indicator;
}

-(void) setModel:(Event*)event_;
-(void) update;

@end
