//
//  InfoDetailViewController.m
//  cocosearch
//
//  Created by yu kawase on 12/12/16.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "InfoDetailViewController.h"

#define IMAGE_URL @"http://img.makesmile.jp/cocosearch/"

@interface InfoDetailViewController ()

@end

@implementation InfoDetailViewController

-(void) initialize{
    self.view.frame = [self viewFrame];
    [self setNaviTitleLabel];
    [self setBackButton];
    [self setViews];
    [self setEvents];
}

-(BOOL) useAllDisplay{
    return YES;
}

// 戻るボタン
-(void) setBackButton{
    [self.navigationItem hidesBackButton];
    UIButton *backB = [UIButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(0, 0, 49.5, 29.5);
    [backB setBackgroundImage:[UIImage imageNamed:@"naviBackButton"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barBackButton = [[UIBarButtonItem alloc]initWithCustomView:backB];
    self.navigationItem.leftBarButtonItem = barBackButton;
}

// ナビゲーションタイトル
-(void) setNaviTitleLabel{
    naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 124)];
    naviTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    naviTitleLabel.textColor = UIColorFromHex(0x885731);
    naviTitleLabel.backgroundColor = [UIColor clearColor];
    naviTitleLabel.shadowColor = UIColorFromHex(0x220e01);
    naviTitleLabel.shadowOffset = CGSizeMake(-1.0f, -1.3f);
    naviTitleLabel.textAlignment = UITextAlignmentCenter;
    
    self.navigationItem.titleView = naviTitleLabel;
}

-(void) setViews{
    [self setSv];
    [self setBg];
    [self setContents];
}

-(void) setSv{
    UIView* view = self.view;
    CGRect svFrame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    sv = [[UIScrollView alloc] initWithFrame:svFrame];
    sv.delegate = self;
    
    [view addSubview:sv];
}

-(void) setBg{
    paperTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailPaperTop"]];
    paperMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailPaperMiddle"]];
    paperBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailPaperBottom"]];
    
    // display
    [sv addSubview:paperTop];
    [sv addSubview:paperMiddle];
    [sv addSubview:paperBottom];
}

-(void) setContents{
    // eventTitle
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColorFromHex(0x885731);
    titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    titleLabel.frame = CGRectMake(25, 29, 180, 20);
    titleLabel.backgroundColor = [UIColor clearColor];
    
    // tweetButton
    twButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twButton setImage:[UIImage imageNamed:@"twitterButton"] forState:UIControlStateNormal];
    [twButton addTarget:self action:@selector(onTw) forControlEvents:UIControlEventTouchUpInside];
    twButton.frame = CGRectMake(220, 15, 29.5f, 34);
    
    // fbButton
    fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setImage:[UIImage imageNamed:@"fbButton"] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(onFb) forControlEvents:UIControlEventTouchUpInside];
    fbButton.frame = CGRectMake(260, 15, 29.5f, 34);
    
    // shopName
    shopNameLabel = [[UILabel alloc] init];
    shopNameLabel.textColor = UIColorFromHex(0x885731);
    shopNameLabel.font = [UIFont systemFontOfSize:13.0f];
    shopNameLabel.frame = CGRectMake(25, 55, 270, 20);
    shopNameLabel.backgroundColor = [UIColor clearColor];
    shopNameLabel.textAlignment = NSTextAlignmentRight;
    
    // imageView
    imageView = [[UIImageView alloc] init];
    
    // description
    descriptionView = [[CocoTextView alloc] init];
    descriptionView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    // ブラウザで開く
    openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openButton setTitleColor:UIColorFromHex(0xaa7953) forState:UIControlStateNormal];
    [openButton setFont:[UIFont boldSystemFontOfSize:14.0f]];
    UIImage* openButtonImage = [[UIImage imageNamed:@"arrowButton"] stretchableImageWithLeftCapWidth:35 topCapHeight:30.5f/2];
    [openButton setBackgroundImage:openButtonImage forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openBrowser) forControlEvents:UIControlEventTouchUpInside];
    openButton.contentStretch = CGRectMake(0.3f, 0.0f, 0.2f, 1.0f);
    [openButton setTitle:@"詳細  " forState:UIControlStateNormal];
    [openButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    [sv addSubview:titleLabel];
    [sv addSubview:twButton];
    [sv addSubview:fbButton];
    [sv addSubview:shopNameLabel];
    [sv addSubview:imageView];
    [sv addSubview:descriptionView];
    [sv addSubview:openButton];
}

-(void) setEvents{
    // スワイプ
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onBack)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
}

-(void) onTw{
    if(onTweet)
        onTweet(self, info.title, info.link);
}

-(void) onFb{
    if(onFacebook)
        onFacebook(self, info.title, info.link);
}


-(void) openBrowser{
    if(onOpenLink)
        onOpenLink(self, info.link);
}

-(void) onLick{
//    [delegate onLink:info.link];
}

-(void) onDetail{
    
//    [delegate onDetail:info.coId];
}

-(void) setNaviButton{
    [self.navigationItem hidesBackButton];
    UIButton *backB = [UIButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(0, 0, 49.5, 29.5);
    [backB setBackgroundImage:[UIImage imageNamed:@"naviBackButton"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barBackButton = [[UIBarButtonItem alloc]initWithCustomView:backB];
    self.navigationItem.leftBarButtonItem = barBackButton;
}

-(void) onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) updateParams{
    naviTitleLabel.text = info.title;
    titleLabel.text = info.title;
    shopNameLabel.text = [NSString stringWithFormat:@"%@ %@", info.shopName, [info getTimeString]];
    descriptionView.text = info.description;
    
    openButton.hidden = ![info hasLink];
}

-(void) updatePositions{
    
    float currentY = 90;
    // TODO
    if(imageView.image != nil){
        CGSize imageSize = imageView.image.size;
        CGRect imageFrame = CGRectMake(35, currentY, imageSize.width, imageSize.height);
        imageView.frame = imageFrame;
        currentY += imageSize.height+5;
    }
    
    currentY = [descriptionView updatePositionY:currentY];
    
    // ブラウザで開く
    currentY += 5;
    openButton.frame = CGRectMake(168, currentY, 121.5, 30.5f);
    currentY += openButton.frame.size.height;
    currentY += 5;
    
    // 背景調整
    paperTop.frame = CGRectMake(3.5f, 10, 313, 44.5f);
    paperMiddle.frame = CGRectMake(3.5f, 10+44.5f, 313, currentY-10-44.5f);
    paperBottom.frame = CGRectMake(3.5f, currentY, 313, 30.5f);
    sv.contentSize = CGSizeMake(320, currentY+40);
    
//    [self resetPosition];
}

-(void) loadImage{
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, info.image];
    [ImageCache loadImage:imageUrl callback:^(UIImage *image, NSString* key) {
        image = [Utils getResizedImage:image width:250];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            [self updatePositions];
        });
    }];
}

// ▼ public ========================

-(void) setModel:(Info*)info_{
    info = info_;
}

-(void) update{
    sv.contentOffset = CGPointMake(0, 0);
    sv.delegate = nil;
    imageView.image = nil;
    [self updateParams];
    [self updatePositions];
    [self loadImage];
}

@end
