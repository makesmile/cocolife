//
//  PopupInnerView.h
//  cocolife
//
//  Created by yu kawase on 13/03/13.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoH1Label.h"
#import "CocoTextView.h"
#import "ImageCache.h"

@interface PopupInnerView : UIView{
    CocoH1Label* titleLabel;
    CocoTextView* descriptionView;
    UIScrollView* scrollView;
    UIImageView* imageView;
}

-(void) setParams:(NSString*)title description:(NSString*)description imageUrl:(NSString*)imageUrl;
-(void) update;

@end
