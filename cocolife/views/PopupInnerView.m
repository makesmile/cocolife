//
//  PopupInnerView.m
//  cocolife
//
//  Created by yu kawase on 13/03/13.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "PopupInnerView.h"

@implementation PopupInnerView

-(id)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void)initialize{
    [self setViews];
}

-(void) setViews{
    // スクロール
    scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:UIColorFromHex(0xfcedd6)];
    
    // 画像
    imageView = [[UIImageView alloc] init];
    [scrollView addSubview:imageView];
    
    // タイトル
    titleLabel = [[CocoH1Label alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:titleLabel];
    
    // 詳細
    descriptionView = [[CocoTextView alloc] init];
    [scrollView addSubview:descriptionView];
    
    [self addSubview:scrollView];
}

-(void) updatePositions{
    float currentY = 0;
    if(imageView.image != nil){
        imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
        currentY += imageView.image.size.height;
    }
    
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = currentY;
    titleFrame.origin.x = 6;
    titleLabel.frame = titleFrame;
    currentY += titleLabel.frame.size.height - 10;
    
    currentY = [descriptionView updatePositionY:currentY];
    CGRect descriptionFrame = descriptionView.frame;
    descriptionFrame.origin.x = 1;
    descriptionView.frame = descriptionFrame;
    
    scrollView.frame = CGRectMake(-5, -5, 270, self.window.frame.size.height-170);
    scrollView.contentSize = CGSizeMake(270, currentY);
    self.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
}

-(void) setParams:(NSString*)title description:(NSString*)description imageUrl:(NSString*)imageUrl{
    titleLabel.text = title;
    descriptionView.text = description;
    [ImageCache loadImage:imageUrl callback:^(UIImage *image, NSString *key) {
        if(![imageUrl isEqualToString:key]) return;
        image = [Utils getResizedImage:image width:270];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            [self updatePositions];
        });
    }];
}

-(void) update{
    [self updatePositions];
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
