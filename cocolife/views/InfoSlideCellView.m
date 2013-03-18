//
//  NewsView.m
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "InfoSlideCellView.h"
#define IMAGE_URL @"http://img.makesmile.jp/cocosearch/"
#define STEP_DELAY 5

@implementation InfoSlideCellView

@synthesize onTapInfo;

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    [self setViews];
    [self setEvents];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newsBg"]];
    self.frame = CGRectMake(0, 5, 320, 176.5f);
    self.clipsToBounds = YES;
    imageViewList = [[NSMutableArray alloc] init];
}

-(void) setViews{
    
    // sv
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, 320, 134)];
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.delegate = self;
    [self addSubview:sv];
    
    // shadow
    UIImageView* underShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsUnderShadow"]];
    underShadow.frame = CGRectMake(-2, 134-12, 322,14);
    [self addSubview:underShadow];
    
    // map
    UIButton* toMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toMapButton setImage:[UIImage imageNamed:@"newsToMap"] forState:UIControlStateNormal];
    toMapButton.frame = CGRectMake(270, 85, 41, 41);
    [self addSubview:toMapButton];
    toMapButton.hidden = YES; // TODO つかわない？ とりあえず非表示
    
    // titleLayer
    titleLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [titleLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f]];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 320-48, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromHex(0xf1e4d6);
    titleLabel.shadowColor = UIColorFromHex(0x100f0f);
    titleLabel.shadowOffset = CGSizeMake(-0.5f, -0.7f);
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [titleLayer addSubview:titleLabel];
    [self addSubview:titleLayer];
    
    // newIcon
    newIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsNewIcon"]];
    newIcon.frame = CGRectMake(10.0f, -37.0f, 31.5f, 37.0f);
    [self addSubview:newIcon];
    
    // potti
    // ページコントロール
    pager = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 140, 320, 20)];
    pager.currentPage = 1;
    pager.currentPageIndicatorImage = [UIImage imageNamed:@"pottiOn"];
    pager.pageIndicatorImage = [UIImage imageNamed:@"pottiOff"];
    [pager setIndicatorMargin:5.0f];
    
    [self addSubview:pager];
}

-(void) setEvents{
    UITapGestureRecognizer* reco = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:reco];
}

-(void) onTap{
    NSLog(@"onTap");
    int page = [self page];
    Info* info = (Info*)[infoList get:page];
    if(onTapInfo)
        onTapInfo(info);
}

-(void) loadImage:(UIButton*)imageView imageUrl:(NSString*)imageUrl{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, imageUrl];
    [ImageCache loadImage:requestUrl callback:^(UIImage *image, NSString *key) {
        UIImage* resizedImage = [Utils clipImage:image rect:CGRectMake(0, 0 , 320, 134)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:resizedImage forState:UIControlStateNormal];
        });
    }];
}

-(int) page{
    return (int)(sv.contentOffset.x / sv.bounds.size.width);
}

// ▼ UISCrollViewDelegate ===================

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self reTimer];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([scrollTimer isValid]){
        [scrollTimer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = [self page];
    
    Info* info = (Info*)[infoList get:page];
    titleLabel.text = info.title;
    
    float toY;
    if([info isNew]){
        toY = 0;
    }else{
        toY = -37.0f;
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        CGRect iconFrame = newIcon.frame;
        iconFrame.origin.y = toY;
        newIcon.frame = iconFrame;
    }];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = [self page];
    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    pager.currentPage = sv.contentOffset.x / 320;
    [self updateInfo];
}

-(void) updateInfo{
    int page = [self page];
    Info* info = (Info*)[infoList get:page];
    titleLabel.text = info.title;
    
    float toY;
    if([info isNew]){
        toY = 0;
    }else{
        toY = -37.0f;
    }
    [[[UIAnimationCommand alloc] initWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animationBlock:^{
        CGRect iconFrame = newIcon.frame;
        iconFrame.origin.y = toY;
        newIcon.frame = iconFrame;
    } completeBlock:^(BOOL finished) {
        
    }] execute:nil];
}

-(void) nextNews{
    int page = [self page];
    int nextPage = page+1;
    if(nextPage >= [infoList count]){
        page = -1;
    }
    
    float toX = ((page+1)*320);
    [sv setContentOffset:CGPointMake(toX, 0) animated:YES];
}

-(void) reTimer{
    if([scrollTimer isValid]){
        [scrollTimer invalidate];
    }
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:STEP_DELAY target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
}

// ▼ public ===============================

-(void) assignModel:(InfoList*)infoList_{
    infoList = infoList_;
}

-(void) update{
    float x = 0;
    
    for(int j=0,jMax=[imageViewList count];j<jMax;j++){
        [[imageViewList objectAtIndex:j] removeFromSuperview];
    }
    [imageViewList removeAllObjects];
    
    CGRect baseFrame = CGRectMake(0, 0, 320, 134);
    for(int i=0,max=[infoList count];i<max;i++){
        Info* info = (Info*)[infoList get:i];
        CGRect frame = CGRectMake(x, 0, 320, 134);
        
        // imageView
        UIButton* imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        if([Utils getMajorVersion] > 5){
            [imageView addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
            [imageView addGestureRecognizer:tapGesture];
        }
        imageView.frame = baseFrame;
        
        // view
        UIView* view = [[UIView alloc] initWithFrame:frame];
        [imageViewList addObject:view];
        
        // loading
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator startAnimating];
        indicator.frame = baseFrame;
        
        // display
        [view addSubview:indicator];
        [view addSubview:imageView];
        [sv addSubview:view];
        x += 320;
        
        [self loadImage:imageView imageUrl:info.image];
    }
    
    // pottiView
    pager.numberOfPages = [infoList count];
    Info* info = (Info*)[infoList get:0];
    titleLabel.text = info.title;
    sv.contentOffset = CGPointMake(0, 0);
    sv.contentSize = CGSizeMake(x, 134);
    
    [self scrollViewDidEndDecelerating:sv];
    [self reTimer];
    
}

@end
