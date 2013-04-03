//
//  DetailViewController.h
//  cocosearch
//
//  Created by yu kawase on 13/01/19.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import "AbstractCocoViewController.h"
#import "Utils.h"
#import "ImageCache.h"
#import "ScrollImageViewer.h"
#import "CocoTextView.h"
#import "CocoH1Label.h"

// model
#import "Coco.h"


// venders
#import "UAModalPanel.h"

typedef void(^onPopup_t)(AbstractCocoViewController* viewController, NSString* title, NSString* description, NSString* imageUrl);
typedef void(^onFavorit_t)(Coco* coco);

@interface DetailViewController : AbstractCocoViewController{
    
    // callback
    onPopup_t onPopup;
    onFavorit_t onFavorit;
    
    // models
    Coco* coco;
    
    // params
    BOOL fromFavorit;
    
    // views
    UILabel* naviTitleLabel;
    UIScrollView* sv;
    UIImageView* paperTop;
    UIImageView* paperMiddle;
    UIImageView* paperBottom;
    UILabel* shopTitleLabel;
    UIButton* twButton;
    UIButton* fbButton;
    UIButton* toKeiroButton;
    UIButton *favoritButton;
    UIImageView* lineView;
    ScrollImageViewer* scrollImageViewer;
    CocoTextView* exerptView;
    CocoTextView* stationView;
    CocoTextView* addressView;
    CocoTextView* telView;
    CocoTextView* hourView;
    CocoTextView* priceView;
    CocoTextView* detailView;
    CocoTextView* urlView;
    CocoH1Label* hourTitle;
    CocoH1Label* priceTitle;
    CocoH1Label* detailTitle;
    UAModalPanel* modalPanel;
}

@property (strong) onFavorit_t onFavorit;
@property (strong) onPopup_t onPopup;

-(void) setModel:(Coco*)coco_;
-(void) update;
-(void) fromFavorit;

@end
