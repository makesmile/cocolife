//
//  ScrollImageViewer.h
//  cocosearch
//
//  Created by yu kawase on 13/01/20.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coco.h"
#import "CocoDetail.h"
#import "ImageCache.h"

typedef void (^onPhotoTap_t)(NSString* title, NSString* description, NSString* url);

@interface ScrollImageViewer : UIView<
UIScrollViewDelegate
>{
    NSTimer* scrollTimer;
    
    // callbacks
    onPhotoTap_t onPhotoTap;
    
    // models
    NSArray* detailList;
    Coco* coco;
    
    // views
    UIPageControl* pageControl;
    UIScrollView* sv;
    NSMutableArray* imageViewList;
    UILabel* titleLabel;
    
    // threadQueue
    dispatch_queue_t mainQueue;
}

@property (strong) onPhotoTap_t onPhotoTap;

-(id) init;
-(void) setModel:(Coco*)coco_;
-(void) update;


@end
