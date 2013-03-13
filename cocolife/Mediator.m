//
//  Mediator.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "Mediator.h"
#define UPDATE_API @"http://api.makesmile.jp/cocosearch/update.php"
#define SECRET_KEY @"q17jc6"
#define CONTACT_URL @"http://api.makesmile.jp/cocosearch/postContact.php"

@implementation Mediator

-(void) initialize{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    loading = NO;
    [ImageCache create];
    [self createController];
    [self assignCallback];
    [self setSwipe];
    [self assignModel];
    [self updateViews];
    [self setViews];
}

// ▼ initialize =================================

-(void) createController{
    loadingViewController = [[LoadingViewController alloc] init];
    topViewController = [[TopViewController alloc] init];
    mapViewController = [[MapViewController alloc] init];
    listViewController = [[ListViewController alloc] init];
    contactViewController = [[ContactViewController alloc] init];
    detailViewController = [[DetailViewController alloc] init];
    infoDetailViewController = [[InfoDetailViewController alloc] init];
    eventDetailViewController = [[EventDetailViewController alloc] init];
    favoritViewController = [[FavoritViewController alloc] init];
}

-(void) assignCallback{
    // ブラウザ開く
    onOpenLink_t onOpenLink = ^(AbstractCocoViewController* viewController, NSString* link){
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString: link]];
    };
    // 店舗選択
    onSelectCoco_t onSelectCoco = ^(AbstractCocoViewController* viewController, Coco* coco){
        [self normalView:viewController];
        [detailViewController setModel:coco];
        [detailViewController update];
        if(viewController == favoritViewController){
            [topViewController.navigationController setNavigationBarHidden:NO animated:YES];
            [topViewController.navigationController pushViewController:detailViewController animated:YES];
            [self hideSide];
        }else{
            [viewController.navigationController setNavigationBarHidden:NO animated:YES];
            [viewController.navigationController pushViewController:detailViewController animated:YES];
        }
    };
    // 全画面
    onAllView_t onAllView = ^(AbstractCocoViewController* viewController){
        [self showAllView:viewController];
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    };
    // 全画面終了
    onNormalView_t onNormalView = ^(AbstractCocoViewController* viewController){
        [self normalView:viewController];
        [viewController.navigationController setNavigationBarHidden:NO animated:YES];
    };
    // facebook
    onFacebook_t onFacebook = ^(AbstractCocoViewController* viewController, NSString* title, NSString* url){
        if([Utils getMajorVersion] < 6 || ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            [self showToast:@"お使いの未満は非対応です、ごめんなさい。"];
            return ;
        }
        
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeCtl setInitialText:title];
        [composeCtl addURL:[NSURL URLWithString:url]];
        [tabBarController presentViewController:composeCtl animated:YES completion:nil];
    };
    // tweet
    onTweet_t onTweet = ^(AbstractCocoViewController* viewController, NSString* title, NSString* url){
        if([Utils getMajorVersion] < 6 || ![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            [self showToast:@"お使いの未満は非対応です、ごめんなさい。"];
            return ;
        }
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composeCtl setInitialText:title];
        [composeCtl addURL:[NSURL URLWithString:url]];
        [tabBarController presentViewController:composeCtl animated:YES completion:nil];
    };
    // 経路
    onKeiro_t onKeiro = ^(AbstractCocoViewController* viewController, int cocoId){
        Coco* coco = [[ModelManager getInstance] createCocoModel:cocoId];
        CLLocationCoordinate2D coordinate = [mapViewController homeLocation].coordinate;
        NSString *urlString = [NSString stringWithFormat: @"comgooglemaps://?directionsmode=transit&daddr=%f,%f&saddr=%f,%f",
                               coco.lat, coco.lng, coordinate.latitude/*35.664035f*/, coordinate.longitude/*139.698212*/
                               ];
        NSLog(@"%@", urlString);
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString: urlString]];
    };
    
    // ブラウザ開く
    detailViewController.onOpenLink = onOpenLink;
    infoDetailViewController.onOpenLink = onOpenLink;
    eventDetailViewController.onOpenLink = onOpenLink;
    
    // 全画面
    topViewController.onNormalView = onNormalView;
    topViewController.onAllView = onAllView;
    detailViewController.onNormalView = onNormalView;
    detailViewController.onAllView = onAllView;
    listViewController.onNormalView = onNormalView;
    listViewController.onAllView = onAllView;
    infoDetailViewController.onAllView = onAllView;
    infoDetailViewController.onNormalView = onNormalView;
    eventDetailViewController.onAllView = onAllView;
    eventDetailViewController.onNormalView = onNormalView;
    
    // share
    eventDetailViewController.onFacebook = onFacebook;
    eventDetailViewController.onTweet = onTweet;
    infoDetailViewController.onFacebook = onFacebook;
    infoDetailViewController.onTweet = onTweet;
    detailViewController.onFacebook = onFacebook;
    detailViewController.onTweet = onTweet;
    
    // 経路
    detailViewController.onKeiro = onKeiro;
    infoDetailViewController.onKeiro = onKeiro;
    eventDetailViewController.onKeiro = onKeiro;
    
    // 店舗詳細へ
    mapViewController.onSelectCoco = onSelectCoco;
    listViewController.onSelectCoco = onSelectCoco;
    favoritViewController.onSelectCoco = onSelectCoco;
    
    // イベント詳細
    topViewController.onSelectEvent = ^(AbstractCocoViewController* viewController, Event* event){
        [self normalView:viewController];
        [eventDetailViewController setModel:event];
        [eventDetailViewController update];
        [viewController.navigationController setNavigationBarHidden:NO animated:YES];
        [viewController.navigationController pushViewController:eventDetailViewController animated:YES];
    };
    // お知らせ選択
    topViewController.onSelectInfo = ^(AbstractCocoViewController* viewController, Info* info){
        [self normalView:viewController];
        [infoDetailViewController setModel:info];
        [infoDetailViewController update];
        [viewController.navigationController setNavigationBarHidden:NO animated:YES];
        [viewController.navigationController pushViewController:infoDetailViewController animated:YES];
    };
    // 左表示非表示
    topViewController.onLeftToggle = ^{
        if(tabBarController.view.frame.origin.x == 0){
            [self showLeft];
        }else{
            [self hideSide];
        }
    };
    // ポップアップ
    detailViewController.onPopup = ^(AbstractCocoViewController* viewController, NSString* title, NSString* description, NSString* imageUrl){
        NSLog(@"onPopupMediator");
        PopupInnerView* innerView = [[PopupInnerView alloc] init];
        CGRect windowBounds = CGRectMake(0, 0, 320, [self getWindowHeight]);
        windowBounds.origin.y = 10;
        windowBounds.size.height -= 10;
        modalPanel = [[CocoModalPanel alloc] initWithFrame:windowBounds];
        modalPanel.margin = UIEdgeInsetsMake(30, 15, 100, 5);
        [modalPanel.contentView addSubview:innerView];
        [window addSubview:modalPanel];
        [innerView setParams:title description:description imageUrl:imageUrl];
        [innerView update];
        [modalPanel show];
    };
    
    // お気に入り
    detailViewController.onFavorit = ^(Coco* coco){
        // メインスレッドでやっちゃおう
        [[ModelManager getInstance] favorit:coco];
        [[ModelManager getInstance] reloadFavoritList];
        [favoritViewController update];
        [self showToast:@"お気に入りに追加しました"];
    };
    // お気に入り削除
    favoritViewController.onDeleteFavorit = ^(Coco* coco){
        [[ModelManager getInstance] unFavorit:coco];
    };
    favoritViewController.onEditMode = ^{
        float duration = 0.02f;
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGRect tabBarFrame = tabBarController.view.frame;
                             tabBarFrame.origin.x = 315;
                             tabBarController.view.frame = tabBarFrame;
                             
                             CGRect shadowFrame = leftShadow.frame;
                             shadowFrame.origin.x = tabBarFrame.origin.x - shadowFrame.size.width;
                             leftShadow.frame = shadowFrame;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    };
    favoritViewController.onNormalMode = ^{
        [self showLeft];
    };
    
    // お問い合わせ
    contactViewController.onSendContact = ^(NSString* name, NSString* mail, NSString* contact){
        [self sendContact:name mailAddress:mail content:contact];
    };
    
    // 初期かエラー
    loadingViewController.onReload = ^{
        [self showToast:@"通信エラー\nしばらく時間をおいてから再度お試し下さい"];
        [self loadUpdateApi];
    };
}

-(void) setSwipe{
    // topView
    UIPanGestureRecognizer* topPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePanGesture:)];
    [topViewController.view addGestureRecognizer:topPanRecognizer];
    
    // favoritView(left)
    UIPanGestureRecognizer* leftPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handlePanGesture:)];
    [favoritViewController.view addGestureRecognizer:leftPanRecognizer];
}

-(void) assignModel{
    // model更新
    ModelManager* mm = [ModelManager getInstance];
    [mm reload];
    
    //　viewController
    [topViewController assignModel:mm.infoList eventList:mm.eventList];
    [listViewController assignModel:mm.cocoList];
    [mapViewController assignModel:mm.cocoList];
    [favoritViewController assignModel:mm.favoritList];
}

-(void) updateViews{
    [topViewController update];
    [mapViewController update];
    [listViewController update];
    [favoritViewController update];
}

-(void) setViews{
    // top
    NavigationController* topNavigationController = [[NavigationController alloc] init];
    [topNavigationController pushViewController:topViewController animated:NO];
    
    // map
    NavigationController* mapNavigationController = [[NavigationController alloc] init];
    [mapNavigationController pushViewController:mapViewController animated:NO];
    
    // list
    NavigationController* listNavigationController = [[NavigationController alloc] init];
    [listNavigationController pushViewController:listViewController animated:NO];
    
    // contact
    NavigationController* contactNavigationController = [[NavigationController alloc] init];
    [contactNavigationController pushViewController:contactViewController animated:NO];
    
    // favorit
    favoritNavigationController = [[NavigationController alloc] init];
    [favoritNavigationController pushViewController:favoritViewController animated:NO];
    
    NSArray* viewControllers = [[NSArray alloc] initWithObjects:topNavigationController
                                , mapNavigationController
                                , listNavigationController
                                , contactNavigationController
                                , nil];
    
    tabBarController = [[TabBarController alloc] initWithHeight:window.frame.size.height];
    [tabBarController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [tabBarController setViewControllers:viewControllers];
    tabBarController.onChangeTab = ^(int index){
        if(index == 1){
            [mapViewController startLocation];
        }else{
            [mapViewController stopLocation];
        }
        [topViewController toTop];
        [listViewController toTop];
        [detailViewController.navigationController popToRootViewControllerAnimated:NO];
    };
    [window addSubview:favoritNavigationController.view];// 左シャドウ
    leftShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftShadow"]];
    leftShadow.frame = CGRectMake(-19, 0, 19, 1136);
    [window addSubview:leftShadow];
    [window addSubview:tabBarController.view];
    [window addSubview:loadingViewController.view];
    [loadingViewController reset];
    
    if([userDefaults integerForKey:@"lastupdated"] != 0){
        loadingViewController.view.hidden = YES;
    }
}

// ▲ initialize ==================================

-(void) becomeActive{
    [self loadUpdateApi];
}

-(void) loadUpdateApi{
    if(loading) return;
    loading = YES;
    int lastupdated = [[userDefaults objectForKey:@"lastupdated"] intValue];
    NSString* requestUrl = [NSString stringWithFormat:@"%@?lastupdated=%d", UPDATE_API, lastupdated];
//    NSLog(@"requestUrl:%@", requestUrl);
    
    loadCommand = [[URLLoadCommand alloc] initWithUrl:requestUrl];
    [loadCommand setOnError:^(URLLoadOperation *operation, NSError *error) {
        loading = NO;
        if(lastupdated == 0)
            [loadingViewController onError];
    }];
    [loadCommand setOnProgress:^(URLLoadOperation *operation, float progress) {
        if(lastupdated == 0)
            [loadingViewController onProgress:progress];
    }];
    BlockCommand* onLoadCommand = [[BlockCommand alloc] initWithBlock:^(NSObject *data) {
        
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:(NSData*)data options:NSJSONReadingAllowFragments error:&error];
        if(error != nil){
            // TODO えらー
            loading = NO;
            return;
        }
        
        [self showLoading];
        dispatch_async([self globalQueue], ^{
            [[ModelManager getInstance] updateData:jsonDic];
            [[ModelManager getInstance] reload];
            dispatch_async([self mainQueue], ^{
                if(lastupdated == 0)
                    [loadingViewController onEnd];
                loading = NO;
                [self updateViews];
                [self hideLoading];
            });
        });
    }];
    
    SerialExecutor* e = [[SerialExecutor alloc] init];
    [e push:loadCommand];
    [e push:onLoadCommand];
    [e execute:nil];
    
}

-(void) memoryWarning{
    [ImageCache clear];
}

-(void) showAllView:(AbstractCocoViewController*)viewController{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    for(UIView *view in tabBarController.view.subviews)
    {
        CGRect _rect = view.frame;
        if([view isKindOfClass:[UITabBar class]] || view.tag >= 100)
        {
            _rect.origin.y = [self getWindowHeight];
            [view setFrame:_rect];
        }
        else {
            _rect.size.height = [self getWindowHeight];
            [view setFrame:_rect];
        }
    }
    [UIView commitAnimations];
}

-(void) normalView:(AbstractCocoViewController*)viewController{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    float _barHeight = tabBarController.tabBar.frame.size.height;
    for(UIView *view in tabBarController.view.subviews)
    {
        CGRect _rect = view.frame;
        if([view isKindOfClass:[UITabBar class]] || view.tag >= 100)
        {
            if(view.tag == 110){ // 影
                _rect.origin.y = [self getWindowHeight] - 50.25f - 12.0f;
            }else{
                _rect.origin.y = [self getWindowHeight] - _rect.size.height;
            }
            [view setFrame:_rect];
            _barHeight = _rect.size.height;
        } else {
            _rect.size.height = [self getWindowHeight] - _barHeight;
            [view setFrame:_rect];
        }
    }
    
    [UIView commitAnimations];
}

-(void) showLeft{
//    notifyNavigationController.view.hidden = YES;
    favoritNavigationController.view.hidden = NO;
    float duration = 0.1f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGRect tabBarFrame = tabBarController.view.frame;
                         tabBarFrame.origin.x = 285;
                         tabBarController.view.frame = tabBarFrame;
                         
                         // leftShadow
                         CGRect shadowFrame = leftShadow.frame;
                         shadowFrame.origin.x = tabBarFrame.origin.x - shadowFrame.size.width;
                         leftShadow.frame = shadowFrame;
                         
                         // rightShadow
//                         CGRect rightShadowFrame = rightShadow.frame;
//                         rightShadowFrame.origin.x = tabBarFrame.origin.x + tabBarFrame.size.width;
//                         rightShadow.frame = rightShadowFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void) hideSide{
//    [favoritViewController normalMode];
    float duration = 0.1f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGRect tabBarFrame = tabBarController.view.frame;
                         tabBarFrame.origin.x = 0;
                         tabBarController.view.frame = tabBarFrame;
                         
                         // leftShadow
                         CGRect leftShadowFrame = leftShadow.frame;
                         leftShadowFrame.origin.x = tabBarFrame.origin.x - leftShadowFrame.size.width;
                         leftShadow.frame = leftShadowFrame;
                         
                         // rightShadow
//                         CGRect rightShadowFrame = rightShadow.frame;
//                         rightShadowFrame.origin.x = tabBarFrame.origin.x + tabBarFrame.size.width;
//                         rightShadow.frame = rightShadowFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void) showRight{
    float duration = 0.1f;
//    notifyNavigationController.view.hidden = NO;
    favoritNavigationController.view.hidden = YES;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGRect tabBarFrame = tabBarController.view.frame;
                         tabBarFrame.origin.x = -320 + 35;
                         tabBarController.view.frame = tabBarFrame;
                         
                         // leftShadow
                         CGRect shadowFrame = leftShadow.frame;
                         shadowFrame.origin.x = tabBarFrame.origin.x - shadowFrame.size.width;
                         leftShadow.frame = shadowFrame;
                         
                         // rightShadow
//                         CGRect rightShadowFrame = rightShadow.frame;
//                         rightShadowFrame.origin.x = tabBarFrame.origin.x + tabBarFrame.size.width;
//                         rightShadow.frame = rightShadowFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void) handlePanGesture:(UIPanGestureRecognizer*)recognizer{
    if(tabBarController.selectedIndex != 0) return;
    if([topViewController.navigationController topViewController] != topViewController) return;
    UIView* tabBarView = tabBarController.view;
    CGRect tabBarFrame = tabBarView.frame;
    CGPoint point = [recognizer translationInView:window];
    
    float speed = point.x;
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        // タッチ終了
        // スピード
        float threshold = 6;
        if(abs(prevSpeed) > 6){
            if(prevSpeed > threshold && tabBarFrame.origin.x > 0){
                [self showLeft];
            }else if(prevSpeed < -threshold && tabBarFrame.origin.x < 0){
                [self showRight];
            }else{
                [self hideSide];
            }
        }else{
            if(tabBarFrame.origin.x < -142){
                [self showRight];
            }else if(tabBarFrame.origin.x > 142){
                [self showLeft];
            }else{
                [self hideSide];
            }
        }
    }else if(recognizer.state == UIGestureRecognizerStateBegan){
        // タッチスタート
        
    }else{
        BOOL showLeft = (tabBarFrame.origin.x > 0);
        favoritNavigationController.view.hidden = !showLeft;
//        notifyNavigationController.view.hidden = showLeft;
        
        // タッチムーブ
        CGRect tabBarFrame = tabBarController.view.frame;
        tabBarFrame.origin.x += speed;
        if(tabBarFrame.origin.x < -285){
            tabBarFrame.origin.x = -285;
        }
        else if(tabBarFrame.origin.x < 0){
            tabBarFrame.origin.x = 0;
        }
        else if(tabBarFrame.origin.x > 285){
            tabBarFrame.origin.x = 285;
        }
        tabBarController.view.frame = tabBarFrame;
        
        // leftShadow
        CGRect leftShadowFrame = leftShadow.frame;
        leftShadowFrame.origin.x = tabBarFrame.origin.x - leftShadowFrame.size.width;
        leftShadow.frame = leftShadowFrame;
        
        // rightShadow
//        CGRect rightShadowFrame = rightShadow.frame;
//        rightShadowFrame.origin.x = tabBarFrame.origin.x + tabBarFrame.size.width;
//        rightShadow.frame = rightShadowFrame;
    }
    
    prevSpeed = speed;
    [recognizer setTranslation:CGPointZero inView:[self getWindow]];
}

-(void) sendContact:(NSString*)name mailAddress:(NSString*)mailAddress content:(NSString*)content{
    // TODO 送信処理
    
    [self showLoading];
    
    NSData *requestData = [[NSString stringWithFormat:@"name=%@&mail=%@&content=%@&secret_key=%@"
                            , name, mailAddress, content, SECRET_KEY
                            ]
                           dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CONTACT_URL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:10.0];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLResponse *resp;
        
        // エラーを格納するオブジェクト
        NSError *err = nil;
        NSData *result = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&resp
                                                           error:&err];
        NSLog(@"%@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(err != nil
               // TODO ここはステータスコードとかだよね
               || ![[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] isEqualToString:@"OK"]
               ){
                [self showToast:@"投稿に失敗しました"];
            }else{
                [self showToast:@"投稿しました"];
                [contactViewController resetForm];
            }
            [self hideLoading];
        });
        
    });

}


@end
