//
//  ScrollImageViewer.m
//  cocosearch
//
//  Created by yu kawase on 13/01/20.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import "ScrollImageViewer.h"
#define IMAGE_URL @"http://img.makesmile.jp/cocosearch/"
#define STEP_DELAY 5

@implementation ScrollImageViewer

@synthesize onPhotoTap;

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    [self setBackgroundColor:[UIColor grayColor]];
    mainQueue = dispatch_get_main_queue();
    
    CGRect baseFrame = CGRectMake(0, 0, 260, 145);
    self.frame = baseFrame;
    
    //
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = baseFrame;
    [self addSubview:indicator];
    [indicator startAnimating];
    
    sv = [[UIScrollView alloc] initWithFrame:baseFrame];
    sv.delegate = self;
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    imageViewList = [[NSMutableArray alloc] init];
    for(int i=0;i<5;i++){
        UIButton* imageView = [[UIButton alloc] initWithFrame:baseFrame];
        imageView.tag = i;
        [imageView addTarget:self action:@selector(onTapImage:) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:imageView];
        [imageViewList addObject:imageView];
        baseFrame.origin.x += baseFrame.size.width;
    }
    
    // titleArea
    UIView* titleLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 20)];
    [titleLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f]];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 255, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromHex(0xf1e4d6);
    titleLabel.shadowColor = UIColorFromHex(0x100f0f);
    titleLabel.shadowOffset = CGSizeMake(-0.5f, -0.7f);
    titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [titleLayer addSubview:titleLabel];

    // pageControl
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(160, 120, 100, 25);

    // display
    [self addSubview:sv];
    [self addSubview:pageControl];
    [self addSubview:titleLayer];
}

-(void) onTapImage:(UIButton*)button{
    int index = button.tag;
        
    // main
    if(index == 0){
        NSString* url = [NSString stringWithFormat:@"%@%@", IMAGE_URL, coco.image];
        if(onPhotoTap)
            onPhotoTap(coco.name, coco.excerpt, url);
        return;
    }
    
    // detail
    CocoDetail* cocoDetail = [detailList objectAtIndex:index-1];
    NSString* url = [NSString stringWithFormat:@"%@%@", IMAGE_URL, cocoDetail.image];
    if(onPhotoTap)
        onPhotoTap(cocoDetail.title, cocoDetail.description, url);
        return;
}

-(void) nextNews{
    int page = [self page];
    int nextPage = page+1;
    if(nextPage >= 5){
        page = -1;
    }
    
    float toX = ((page+1)*sv.frame.size.width);
    [sv setContentOffset:CGPointMake(toX, 0) animated:YES];
}

-(void) reTimer{
    if([scrollTimer isValid]){
        [scrollTimer invalidate];
    }
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:STEP_DELAY target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
}

-(int) page{
    return (int)(sv.contentOffset.x / sv.bounds.size.width);
}

// public ========================================

-(void) setModel:(Coco*)coco_{
    coco = coco_;
    detailList = [coco getDetailList];
}

-(void) update{
    sv.contentOffset = CGPointMake(0, 0);
    int detailNum = [detailList count];
    for(int i=0;i<5;i++){
        UIButton* imageView = [imageViewList objectAtIndex:i];
        if(i==0){
            NSString* imageUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, coco.image];
            [imageView setImage:nil forState:UIControlStateNormal];
            [ImageCache loadImage:imageUrl callback:^(UIImage *image, NSString* key) {
                if(![imageUrl isEqualToString:key]){
                    return;
                }
                image = [Utils getResizedImage:image width:260];
                if(image.size.height > 145){
                    image = [Utils clipImage:image rect:CGRectMake(0, 0, 260, 145)];
                }
                dispatch_async(mainQueue, ^{
                    [imageView setImage:image forState:UIControlStateNormal];
                });
            }];
            continue;
        }
        CocoDetail* cocoDetail = [detailList objectAtIndex:i-1];
        imageView.hidden = NO;
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, cocoDetail.image];
        [imageView setImage:nil forState:UIControlStateNormal];
        
        [ImageCache loadImage:imageUrl callback:^(UIImage *image, NSString* key) {
            if(![imageUrl isEqualToString:key]){
                return;
            }
            image = [Utils getResizedImage:image width:260];
            if(image.size.height > 145){
                image = [Utils clipImage:image rect:CGRectMake(0, 0, 260, 145)];
            }
            dispatch_async(mainQueue, ^{
                [imageView setImage:image forState:UIControlStateNormal];
            });
        }];
    }
    
    pageControl.numberOfPages = 5;
    sv.contentSize = CGSizeMake(5*260, 145);
    titleLabel.text = coco.station;
    
    [self reTimer];
}

// ▼ UIScrollViewDelegate ======================

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self reTimer];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([scrollTimer isValid]){
        [scrollTimer invalidate];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    pageControl.currentPage = currentPage;
    
    if(currentPage == 0){
        titleLabel.text = coco.station;
        return;
    }
    CocoDetail* cocoDetail = [detailList objectAtIndex:currentPage-1];
    titleLabel.text = cocoDetail.title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
