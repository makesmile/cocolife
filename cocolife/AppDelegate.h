//
//  AppDelegate.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Mediator.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Mediator* mediator;
}

@property (strong, nonatomic) UIWindow *window;

@end
