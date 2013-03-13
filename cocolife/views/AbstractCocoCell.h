//
//  AbstractCocoCell.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coco.h"
#import "ImageCache.h"

#define IMAGE_URL @"http://img.makesmile.jp/cocosearch/"

@interface AbstractCocoCell : UITableViewCell{
    // models
    Coco* coco;
    
    // views
    UIImageView* thumbImageView;
    UILabel* titleLabel;
    UILabel* excerptView;
    UILabel* accessLabel;
    UIImageView* newIconView;
    
    UIActivityIndicatorView* indicator;
}

-(void) initialize;
-(void) setModel:(Coco*)coco_;
-(void) update;

@end
