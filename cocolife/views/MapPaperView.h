//
//  MapPaperView.h
//  cocosearch
//
//  Created by yu kawase on 12/12/26.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coco.h"
#import "ImageCache.h"

typedef void (^onPaperTap_t)(Coco* coco);

@interface MapPaperView : UIView{
    
    // models
    Coco* coco;
    
    // callbacks
    onPaperTap_t onPaperTap;
    
    // views
    UIButton* button;
    UIImageView* bgImageView;
    UIImageView* imageView;
    UILabel* nameLabel;
    UILabel* stationLabel;
    UILabel* descriptionLabel;
}

@property (strong) onPaperTap_t onPaperTap;

-(void) setModel:(Coco*)coco_;
-(void) update;

@end
