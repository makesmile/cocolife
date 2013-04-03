//
//  DetailViewController.m
//  cocosearch
//
//  Created by yu kawase on 13/01/19.
//  Copyright (c) 2013年 cocosearch. All rights reserved.
//

#import "DetailViewController.h"
#import "Mediator.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize onPopup;
@synthesize onFavorit;

-(void) initialize{
    self.view.frame = [self viewFrame];
    [self setViews];
    [self setBackButton];
    [self setFavoritButton];
    [self setNaviTitleLabel];
    [self setEvents];
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
    // shopTitle
    shopTitleLabel = [[UILabel alloc] init];
    shopTitleLabel.textColor = UIColorFromHex(0x885731);
    shopTitleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    shopTitleLabel.frame = CGRectMake(25, 29, 180, 20);
    shopTitleLabel.backgroundColor = [UIColor clearColor];
    
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
    
    // imageViewer
    scrollImageViewer = [[ScrollImageViewer alloc] init];
    CGRect viewerFrame = scrollImageViewer.frame;
    viewerFrame.origin.x = 30;
    viewerFrame.origin.y = 60;
    scrollImageViewer.frame = viewerFrame;
    scrollImageViewer.onPhotoTap = ^(NSString* title, NSString* description, NSString* imageUrl){
        if(onPopup){
            onPopup(self, title, description, imageUrl);
        }
    };
    
    // line
    lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailLine"]];
    
    // 経路
    toKeiroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* buttonImage = [[UIImage imageNamed:@"toKeiroButton"] stretchableImageWithLeftCapWidth:35 topCapHeight:30.5f/2];
    [toKeiroButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [toKeiroButton addTarget:self action:@selector(toKeiro) forControlEvents:UIControlEventTouchUpInside];
    toKeiroButton.contentStretch = CGRectMake(0.3f, 0.0f, 0.2f, 1.0f);
    [toKeiroButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    toKeiroButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    // text
    exerptView = [[CocoTextView alloc] init];
    stationView = [[CocoTextView alloc] init];
    addressView = [[CocoTextView alloc] init];
    telView = [[CocoTextView alloc] init];
    hourView = [[CocoTextView alloc] init];
    priceView = [[CocoTextView alloc] init];
    detailView = [[CocoTextView alloc] init];
    urlView = [[CocoTextView alloc] init];
    urlView.dataDetectorTypes = UIDataDetectorTypeLink;
    hourTitle = [[CocoH1Label alloc] init];
    priceTitle = [[CocoH1Label alloc] init];
    detailTitle = [[CocoH1Label alloc] init];
    
    // display
    [sv addSubview:shopTitleLabel];
    [sv addSubview:twButton];
    [sv addSubview:fbButton];
    [sv addSubview:scrollImageViewer];
    [sv addSubview:exerptView];
    [sv addSubview:stationView];
    [sv addSubview:addressView];
    [sv addSubview:telView];
    [sv addSubview:toKeiroButton];
    [sv addSubview:lineView];
    [sv addSubview:hourTitle];
    [sv addSubview:hourView];
    [sv addSubview:priceTitle];
    [sv addSubview:priceView];
    [sv addSubview:detailTitle];
    [sv addSubview:detailView];
    [sv addSubview:urlView];
}

-(void) setEvents{
    // スワイプ
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onBack)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
}

-(void) onTw{
    NSString* str = [NSString stringWithFormat:@"%@\n%@", coco.name, coco.excerpt];
    if([str length] > 110){
        str = [str substringToIndex:110];
    }
    if(onTweet)
        onTweet(self, str, coco.url);
}

-(void) onFb{
    NSString* str = [NSString stringWithFormat:@"%@\n%@", coco.name, coco.excerpt];
    if([str length] > 110){
        str = [str substringToIndex:110];
    }
    if(onFacebook)
        onFacebook(self, str, coco.url);
}

-(void) toKeiro{
    if(onKeiro)
        onKeiro(self, coco.id_);
//    [delegate openMap:coco viewController:self];
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

-(void) setFavoritButton{
    // おきにいり　
    [self.navigationItem hidesBackButton];
    favoritButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoritButton.frame = CGRectMake(0, 0, 35, 33.5f);
    [favoritButton setBackgroundImage:[UIImage imageNamed:@"favoritButton"] forState:UIControlStateNormal];
    [favoritButton addTarget:self action:@selector(favoritTap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barBackButton = [[UIBarButtonItem alloc]initWithCustomView:favoritButton];
    self.navigationItem.rightBarButtonItem = barBackButton;
}

-(void) favoritTap{
    favoritButton.enabled = NO;
    if(onFavorit)
        onFavorit(coco);
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
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if(onNormalView)
        onNormalView(self);
    if(fromFavorit){
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) updateViewParams{
    // タイトル
    naviTitleLabel.text = coco.name;
    shopTitleLabel.text = coco.name;
    
    // お気に入り
    favoritButton.enabled = ![coco isFavorit];
    
    // imageViewer
    [scrollImageViewer setModel:coco];
    [scrollImageViewer update];
    
    // text
    exerptView.text = coco.excerpt;
    stationView.text = coco.station;
    addressView.text = coco.address;
    telView.text = coco.tel;
    
    // 
    [toKeiroButton setTitle:[NSString stringWithFormat:@"   %@への経路        ", coco.name] forState:UIControlStateNormal];
    
    hourTitle.text = @"利用可能時間";
    hourView.text = coco.hour;
    priceTitle.text = @"利用料金";
    priceView.text = coco.price;
    detailTitle.text = [NSString stringWithFormat:@"%@とは", coco.name];
    detailView.text = coco.description;
    urlView.text = coco.url;
}

-(BOOL) useAllDisplay{
    return YES;
}

-(void) updateViewPositions{
    
    paperTop.frame = CGRectMake(3.5f, 10, 313, 44.5f);
    // TODO モロモロ
    float currentY = 210;
    
    currentY = [exerptView updatePositionY:currentY];
    currentY = [stationView updatePositionY:currentY];
    currentY = [addressView updatePositionY:currentY];
    currentY = [telView updatePositionY:currentY] + 10;
    
    [toKeiroButton setTitleColor:UIColorFromHex(0xaa7953) forState:UIControlStateNormal];
    [toKeiroButton setFont:[UIFont boldSystemFontOfSize:14.0f]];
    NSString* keiroText = toKeiroButton.titleLabel.text;
    CGSize size = [keiroText sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
                        constrainedToSize:CGSizeMake(260, 30.5f)
                            lineBreakMode:UILineBreakModeHeadTruncation];
    CGRect toKeiroFrame = CGRectMake(290.0f-(size.width), currentY, size.width, 30.5f);
    toKeiroButton.frame = toKeiroFrame;
    toKeiroButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    currentY += toKeiroFrame.size.height + 20;
    CGRect lineFrame = CGRectMake(20, currentY, 280, 0.5f);
    lineView.frame = lineFrame;
    
    currentY += 10;
    currentY = [hourTitle updatePositionY:currentY];
    currentY = [hourView updatePositionY:currentY];
    currentY = [priceTitle updatePositionY:currentY];
    currentY = [priceView updatePositionY:currentY];
    currentY = [detailTitle updatePositionY:currentY];
    currentY = [detailView updatePositionY:currentY];
    currentY = [urlView updatePositionY:currentY];
    
    // 背景調整
    paperMiddle.frame = CGRectMake(3.5f, 10+44.5f, 313, currentY-10-44.5f);
    paperBottom.frame = CGRectMake(3.5f, currentY, 313, 30.5f);
    
    sv.contentSize = CGSizeMake(320, currentY+40);
}

-(void) showPopup:(UIImage*)image title:(NSString*)title description:(NSString*)description{
    float currentY = 0;
    image = [Utils getResizedImage:image width:270];
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:UIColorFromHex(0xfcedd6)];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [scrollView addSubview:imageView];
    CGRect windowBounds = CGRectMake(0, 0, 320, [mediator getWindowHeight]);
    windowBounds.origin.y = 10;
    windowBounds.size.height -= 10;
    modalPanel = [[UAModalPanel alloc] initWithFrame:windowBounds];
    modalPanel.autoresizingMask =
    UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    modalPanel.autoresizesSubviews = YES;
    modalPanel.delegate = self;
    modalPanel.margin = UIEdgeInsetsMake(30, 15, 100, 5);
    modalPanel.shouldBounce = YES;
    
    currentY += image.size.height;
    
    CocoH1Label* titleLabel = [[CocoH1Label alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.text = title;
    CGRect titleFrame = titleLabel.frame;
    titleFrame.size.height *= 2;
    titleFrame.origin.y = currentY;
    titleFrame.origin.x = 6;
    titleLabel.frame = titleFrame;
    
    [scrollView addSubview:titleLabel];
    currentY += titleLabel.frame.size.height - 10;
    
    CocoTextView* descriptionView = [[CocoTextView alloc] init];
    descriptionView.text = description;
    [scrollView addSubview:descriptionView];
    currentY = [descriptionView updatePositionY:currentY];
    CGRect descriptionFrame = descriptionView.frame;
    descriptionFrame.origin.x = 1;
    descriptionView.frame = descriptionFrame;
    
    scrollView.frame = CGRectMake(-5, 0, 270, [mediator getWindowHeight]-180);
    scrollView.contentSize = CGSizeMake(270, currentY);
    
    [modalPanel.contentView addSubview:scrollView];
    [self.view.window addSubview:modalPanel];
    [modalPanel show];
}

// ▼ ScrollImageViewerDelegate =================

-(void) onSelectDetail:(UIImage *)image title:(NSString *)title description:(NSString *)description{
    [self showPopup:image title:title description:description];
}

// ▼ public ====================================

-(void) setModel:(Coco*)coco_{
    coco = coco_;
    fromFavorit = NO;
}

-(void) fromFavorit{
    fromFavorit = YES;
}

-(void) update{
    sv.contentOffset = CGPointMake(0, 0);
    [self updateViewParams];
    [self updateViewPositions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
