//
//  LoadingViewController.m
//  cocosearch
//
//  Created by yu kawase on 12/12/09.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "LoadingViewController.h"
#import "Mediator.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize onReload;

-(void) initialize{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 10;
    self.view.frame = viewFrame;
    
    [self setBg];
    [self setBarImage];
    [self setReloadButton];
    [self setBlackLayer];
}

-(void) setBlackLayer{
    blackLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [blackLayer setBackgroundColor:[UIColor blackColor]];
    blackLayer.alpha = 0.0f;
    [self.view addSubview:blackLayer];
}
// ▼ public ======================================================

-(void)onProgress:(float)progress{
    float width = 254.0f*progress;
    if(width < 30) width = 30.0f;
    if(self.view.window.frame.size.height >= 568){
        barImageView.frame = CGRectMake(33.7f, 278.0f, width, 9.5f);
    }else{
        barImageView.frame = CGRectMake(33.7f, 234.3f, width, 9.5f);
    }
}

-(void) onEnd{
    [UIView animateWithDuration:2.0f animations:^{
        blackLayer.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            loading = NO;
            [self.view setHidden:YES];
        }];
    }];
}

-(void) onError{
    reloadButton.hidden = NO;
    barImageView.hidden = YES;
}


-(void) reset{
    [self.view setHidden:NO];
    reloadButton.hidden = YES;
     barImageView.hidden = NO;
    if(self.view.window.frame.size.height >= 568){
        barImageView.frame = CGRectMake(33.7f, 278.0f, 30.0f, 9.5f);
    }else{
        barImageView.frame = CGRectMake(33.7f, 234.3f, 30.0f, 9.5f);
    }
}

-(void) showReloadButton{
    reloadButton.hidden = NO;
}

-(void) hideReloadButton{
    reloadButton.hidden = YES;
}

// ▼ private =====================================================

-(void) setBg{
    UIImageView* bgImage;
    if([mediator getWindowHeight] >= 568){
        bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingBg-568h"]];
        bgImage.frame = self.view.frame;
    }else{
        bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingBg"]];
        bgImage.frame = self.view.frame;
    }
    
    [self.view addSubview:bgImage];
}

-(void) setBarImage{
    barImageView = [[UIImageView alloc] init];
    
//    barImageView.frame = CGRectMake(20.0, 0.0, 10.0, 10.0);
    barImageView.contentStretch = CGRectMake(0.05, 0, 0.9, 1);
    barImageView.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"bar01"],
                                    [UIImage imageNamed:@"bar02"],
                                    [UIImage imageNamed:@"bar03"],
                                    [UIImage imageNamed:@"bar04"],
                                    [UIImage imageNamed:@"bar05"],
                                    nil
                                    ];
    barImageView.animationDuration = 0.15f;
    barImageView.animationRepeatCount = 0;
    [barImageView startAnimating];
    
    [self.view addSubview:barImageView];
    
    if([mediator getWindowHeight] >= 568){
        barImageView.frame = CGRectMake(33.7f, 278.0f, 10.0f, 9.5f);
    }else{
        barImageView.frame = CGRectMake(20.0f, 200.0f, 10.0f, 9.5f);
    }
}

-(void) setReloadButton{
    reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"reloadButton"] forState:UIControlStateNormal];
    reloadButton.frame = CGRectMake((320-130)/2, 380, 130, 63.5f);
    [reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.hidden = YES;
    
    [self.view addSubview:reloadButton];
}

-(void) reload{
    if(onReload)
        onReload();
}

-(void) initialized{
    
}



@end
