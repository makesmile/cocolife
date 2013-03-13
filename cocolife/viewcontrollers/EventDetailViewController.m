//
//  EventDetailViewController.m
//  cocosearch
//
//  Created by yu kawase on 12/12/25.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Mediator.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

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

-(void) onBack{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    eventTitleLabel = [[UILabel alloc] init];
    eventTitleLabel.textColor = UIColorFromHex(0x885731);
    eventTitleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    eventTitleLabel.frame = CGRectMake(25, 29, 180, 20);
    eventTitleLabel.backgroundColor = [UIColor clearColor];
    
    // shopName
    shopNameLabel = [[UILabel alloc] init];
    shopNameLabel.textColor = UIColorFromHex(0x885731);
    shopNameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    shopNameLabel.backgroundColor = [UIColor clearColor];
    
    // image
    imageView = [[UIImageView alloc] init];
    imageBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventImageBg"]];
    imageBgView.contentStretch = CGRectMake(0.2f, 0.2f, 0.6f, 0.6f);
    
    //
    calenderIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventCalenderIcon"]];
    mapIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventMapIcon"]];
    
    // infoLabel
    periodLabel = [[UILabel alloc] init];
    accessLabel = [[UILabel alloc] init];
    periodLabel.font = accessLabel.font = [UIFont systemFontOfSize:13.0f];
    periodLabel.textColor = accessLabel.textColor = UIColorFromHex(0x885731);
    periodLabel.backgroundColor = accessLabel.backgroundColor = [UIColor clearColor];
    
    // description
    descriptionView = [[CocoTextView alloc] init];
    descriptionView.dataDetectorTypes = UIDataDetectorTypeLink;
    
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
    
    // 経路
    toKeiroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toKeiroButton setTitleColor:UIColorFromHex(0xaa7953) forState:UIControlStateNormal];
    [toKeiroButton setFont:[UIFont boldSystemFontOfSize:14.0f]];
    UIImage* buttonImage = [[UIImage imageNamed:@"toKeiroButton"] stretchableImageWithLeftCapWidth:35 topCapHeight:30.5f/2];
    [toKeiroButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [toKeiroButton addTarget:self action:@selector(toKeiro) forControlEvents:UIControlEventTouchUpInside];
    toKeiroButton.contentStretch = CGRectMake(0.3f, 0.0f, 0.2f, 1.0f);
    [toKeiroButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    toKeiroButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    // ブラウザで開く
    openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openButton setTitleColor:UIColorFromHex(0xaa7953) forState:UIControlStateNormal];
    [openButton setFont:[UIFont boldSystemFontOfSize:14.0f]];
    UIImage* openButtonImage = [[UIImage imageNamed:@"arrowButton"] stretchableImageWithLeftCapWidth:35 topCapHeight:30.5f/2];
    [openButton setBackgroundImage:openButtonImage forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openBrowser) forControlEvents:UIControlEventTouchUpInside];
    openButton.contentStretch = CGRectMake(0.3f, 0.0f, 0.2f, 1.0f);
    [openButton setTitle:@"イベント詳細  " forState:UIControlStateNormal];
    [openButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    openButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    // 詳細へ
    toShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toShopButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [toShopButton addTarget:self action:@selector(toKeiro) forControlEvents:UIControlEventTouchUpInside];
    toShopButton.contentStretch = CGRectMake(0.3f, 0.0f, 0.2f, 1.0f);
    [toShopButton setTitle:@"店舗詳細" forState:UIControlStateNormal];
    [toShopButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    toShopButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    [sv addSubview:eventTitleLabel];
    [sv addSubview:imageBgView];
    [sv addSubview:imageView];
    [sv addSubview:twButton];
    [sv addSubview:fbButton];
    [sv addSubview:shopNameLabel];
    [sv addSubview:calenderIcon];
    [sv addSubview:mapIcon];
    [sv addSubview:periodLabel];
    [sv addSubview:accessLabel];
    [sv addSubview:descriptionView];
    [sv addSubview:toKeiroButton];
    [sv addSubview:openButton];
}

-(void) onTw{
    if(onTweet)
        onTweet(self, event.name, event.link);
//    [delegate onTweetEvent:event];
}

-(void) onFb{
    if(onFacebook)
        onFacebook(self, event.name, event.link);
//    [delegate onFacebookEvent:event];
}

-(void) toKeiro{
    if(onKeiro){
        onKeiro(self, event.coId);
    }
//    Coco* coco = [Db createCoModel:event.coId];
//    [mediator openMap:coco viewController:self];
}

-(void) openBrowser{
    if(onOpenLink)
        onOpenLink(self, event.link);
}

-(void) setEvents{
    // スワイプ
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onBack)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
}

-(void) updatePositions{
    // スクロールリセット
    sv.contentOffset = CGPointMake(0, 0);
    
    shopNameLabel.frame = CGRectMake(130, 57, 160, 20);
    calenderIcon.frame = CGRectMake(127.5f, 80, 19, 15.5f);
    mapIcon.frame = CGRectMake(130.0f, 100, 14, 18.5f);
    accessLabel.frame = CGRectMake(147, 100, 145, 20);
    periodLabel.frame = CGRectMake(147, 80, 145, 20);
    
    float currentY = 130;
    currentY = [descriptionView updatePositionY:currentY];
    
    // 経路開く
    NSString* keiroText = toKeiroButton.titleLabel.text;
    CGSize size = [keiroText sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
                        constrainedToSize:CGSizeMake(260, 30.5f)
                            lineBreakMode:UILineBreakModeHeadTruncation];
    CGRect toKeiroFrame = CGRectMake(290.0f-(size.width), currentY, size.width, 30.5f);
    toKeiroButton.frame = toKeiroFrame;
    toKeiroButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    currentY += toKeiroFrame.size.height;
    
    currentY += 10;
    
    // ブラウザで開く
    openButton.frame = CGRectMake(148, currentY, 141.5, 30.5f);
    currentY += openButton.frame.size.height;
    
    currentY += 0;
    // 背景調整
    paperTop.frame = CGRectMake(3.5f, 10, 313, 44.5f);
    paperMiddle.frame = CGRectMake(3.5f, 10+44.5f, 313, currentY-10-44.5f);
    paperBottom.frame = CGRectMake(3.5f, currentY, 313, 30.5f);
    sv.contentSize = CGSizeMake(320, currentY+40);
    
    NSString* requestUrl = event.image;
    imageView.image = nil;
    imageBgView.hidden = YES;
    [ImageCache loadImage:requestUrl callback:^(UIImage *image, NSString* key) {
        if(![requestUrl isEqualToString:key]){
            return;
        }
        image = [Utils getResizedImage:image height:60];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            CGRect imageFrame = CGRectMake(30, 60, image.size.width, image.size.height);
            imageView.frame =imageFrame;
            imageFrame.origin.x -= 1.5f;
            imageFrame.origin.y -= 1.5f;
            imageFrame.size.width += 3.8f;
            imageFrame.size.height += 3.8f;
            imageBgView.frame = imageFrame;
            imageBgView.hidden = NO;
            
            float x = imageFrame.size.width + imageFrame.origin.x + 8;
            shopNameLabel.frame = CGRectMake(x, 57, 300-x, 20);
            calenderIcon.frame = CGRectMake(x-2.5f, 80, 19, 15.5f);
            mapIcon.frame = CGRectMake(x, 100, 14, 18.5f);
            accessLabel.frame = CGRectMake(x+19, 100, 300-x-19, 20);
            periodLabel.frame = CGRectMake(x+19, 78, 300-x-19, 20);
        });
    }];
}

-(void) updateParams{
    // テキスト
    naviTitleLabel.text = event.name;
    eventTitleLabel.text = event.name;
    accessLabel.text = event.station;
    shopNameLabel.text = event.owner;
    if([[event getStartTimeString] isEqualToString:[event getEndTimeString]] /* TODO この条件はモデルに入れちゃうか? */){
        periodLabel.text = [event getStartTimeString];
    }else{
        periodLabel.text = [NSString stringWithFormat:@"%@〜%@", [event getStartTimeString], [event getEndTimeString]];
    }
    
    NSMutableString* descriptionText = [[NSMutableString alloc] init];
    [descriptionText appendFormat:@"%@\n", event.category];
    [descriptionText appendFormat:@"%@\n", event.description];
    descriptionView.text = descriptionText;
    
    // TODOだっせ
    [toKeiroButton setTitle:[NSString stringWithFormat:@"   %@への経路        ", event.owner] forState:UIControlStateNormal];
}

// ▼ public ===========================

-(void) setModel:(Event*)event_{
    event = event_;
    
}

-(void) update{
    sv.contentOffset = CGPointMake(0, 0);
    [self updateParams];
    [self updatePositions];
}

@end
