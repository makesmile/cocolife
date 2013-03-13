//
//  AbstractCocoViewController.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractViewController.h"
#import "Coco.h"
#import "Event.h"

@class AbstractCocoViewController;

typedef void (^onSelectCoco_t)(AbstractCocoViewController* viewController, Coco* coco);
typedef void (^onAllView_t)(AbstractCocoViewController* viewController);
typedef void (^onNormalView_t)(AbstractCocoViewController* viewController);

typedef void (^onFacebook_t)(AbstractCocoViewController* viewController, NSString* title, NSString* url);
typedef void (^onTweet_t)(AbstractCocoViewController* viewController, NSString* title, NSString* url);
typedef void (^onKeiro_t)(AbstractCocoViewController* viewController, int cocoId);
typedef void (^onOpenLink_t)(AbstractCocoViewController* viewController, NSString* link);

@interface AbstractCocoViewController : AbstractViewController<
UIScrollViewDelegate
>{
    // cllbacks
    onSelectCoco_t onSelectCoco;
    onAllView_t onAllView;
    onNormalView_t onNormalView;
    onFacebook_t onFacebook;
    onTweet_t onTweet;
    onKeiro_t onKeiro;
    onOpenLink_t onOpenLink;
    
    //params
    BOOL scrolling;
    CGPoint scrollBeginingPoint;
}

@property (strong) onSelectCoco_t onSelectCoco;
@property (strong) onAllView_t onAllView;
@property (strong) onNormalView_t onNormalView;
@property (strong) onFacebook_t onFacebook;
@property (strong) onTweet_t onTweet;
@property (strong) onKeiro_t onKeiro;
@property (strong) onOpenLink_t onOpenLink;

-(void) update;
-(float) viewHeight;
-(CGRect) viewFrame;
-(BOOL) useAllDisplay;

@end
