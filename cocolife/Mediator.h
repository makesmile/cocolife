//
//  Mediator.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <Social/Social.h>

// Mediator
#import "BasicMediator.h"

// models
#import "ModelManager.h"

// viewControllers
#import "LoadingViewController.h"
#import "TopViewController.h"
#import "MapViewController.h"
#import "ListViewController.h"
#import "ContactViewController.h"
#import "DetailViewController.h"
#import "InfoDetailViewController.h"
#import "EventDetailViewController.h"
#import "FavoritViewController.h"

// command
#import "SerialExecutor.h"
#import "URLLoadCommand.h"
#import "BlockCommand.h"
#import "FbEventFeedComand.h"

// controllers
#import "NavigationController.h"
#import "TabBarController.h"

// views
#import "PopupInnerView.h"

// venders
#import "CocoModalPanel.h"
#import "GAI.h"

@interface Mediator : BasicMediator{
    
    // viewControllers
    LoadingViewController* loadingViewController;
    TopViewController* topViewController;
    MapViewController* mapViewController;
    ListViewController* listViewController;
    ContactViewController* contactViewController;
    DetailViewController* detailViewController;
    InfoDetailViewController* infoDetailViewController;
    EventDetailViewController* eventDetailViewController;
    FavoritViewController* favoritViewController;
    
    // views
    UIImageView* leftShadow;
    CocoModalPanel* modalPanel;
    
    // params
    float prevSpeed;
    BOOL loading;
    
    // command
    URLLoadCommand* loadCommand;
    
    // controllers TODO インスタンス変数に取っとかないと消える。 ARCノシヨウ？そんなことは
    TabBarController* tabBarController;
    NavigationController* favoritNavigationController;
    id<GAITracker> tracker;
    
}

@end
