//
//  NavigationController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBg"] forBarMetrics:UIBarMetricsDefault];
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
