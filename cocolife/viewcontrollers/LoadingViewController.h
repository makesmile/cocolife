//
//  LoadingViewController.h
//  cocosearch
//
//  Created by yu kawase on 12/12/09.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "AbstractCocoViewController.h"
#import "URLLoadOperation.h"

typedef void (^onReload_t)();

@interface LoadingViewController : AbstractCocoViewController{
    UIImageView* barImageView;
    UIButton* reloadButton;
    UIView* blackLayer;
    
    // flags
    BOOL loading;
    
    // callbacks
    onReload_t onReload;
}

@property (strong) onReload_t onReload;

-(void) reset;
-(void) showReloadButton;
-(void) hideReloadButton;
-(void) onProgress:(float)progress;
-(void) onEnd;
-(void) onError;

@end
