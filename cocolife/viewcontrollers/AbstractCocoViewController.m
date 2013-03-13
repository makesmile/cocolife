//
//  AbstractCocoViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoViewController.h"

@interface AbstractCocoViewController ()

@end

@implementation AbstractCocoViewController

@synthesize onSelectCoco;
@synthesize onAllView;
@synthesize onNormalView;
@synthesize onFacebook;
@synthesize onTweet;
@synthesize onKeiro;
@synthesize onOpenLink;

-(void) update{
    
}

-(float) viewHeight{
    return windowHeight - 20 - 65.0f - 35.0f + 3.0f;
}

-(CGRect) viewFrame{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 4.0f;
    viewFrame.size.height = viewFrame.size.height - 65.0f - 35.0f + 4.0f;
    
    return viewFrame;
}

-(BOOL) useAllDisplay{
    return NO;
}

// ▼UIScrolViewDelegate 実装 ================================

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![self useAllDisplay])return;
    if(scrollView.contentSize.height <= windowHeight+150/*てきとう*/)
        return;
    CGPoint currentPoint = [scrollView contentOffset];
    float sa = scrollView.contentSize.height - currentPoint.y - scrollView.frame.size.height;
    if(currentPoint.y <= 0/* || scrollBeginingPoint.y > (scrollView.contentSize.height - scrollView.frame.size.height)*/)
        return;
    if(!scrolling) return;
    
    if(scrollBeginingPoint.y > currentPoint.y){
        [UIView animateWithDuration:0.2f animations:^{
            scrollView.frame = CGRectMake(0, 4, 320, windowHeight- 65.0f - 35.0f - 20.0f + 4.0f);
        } completion:^(BOOL finished){
            //            showing = NO;
            //            NSLog(@"finish");
        }];
        if(onNormalView)
            onNormalView(self);
    }else {
        if(sa <= 0) return;
        CGRect currentFrame = self.view.frame;
        currentFrame.size.height += 50;
        self.view.frame = currentFrame;
        
        [UIView animateWithDuration:0.2f animations:^{
            scrollView.frame = CGRectMake(0, 0, 320, windowHeight-20);
        }];
        if(onAllView)
            onAllView(self);
    }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(![self useAllDisplay])return;
    scrolling = YES;
    scrollBeginingPoint = [scrollView contentOffset];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![self useAllDisplay])return;
    CGPoint currentPoint = [scrollView contentOffset];
    float sa = scrollView.contentSize.height - currentPoint.y - scrollView.frame.size.height;
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(![self useAllDisplay])return;
    scrolling = NO;
}

@end
