//
//  ModelManager.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager

@synthesize infoList;
@synthesize eventList;
@synthesize notifyList;
@synthesize cocoList;
@synthesize favoritList;

static ModelManager* instance;

+(ModelManager*)getInstance{
    if(instance == nil){
        instance = [[ModelManager alloc] init];
    }
    
    return instance;
}

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    NSLog(@"create models");
    // model生成
    infoList = [[InfoList alloc] init];
    eventList = [[EventList alloc] init];
    notifyList = [[NotifyList alloc] init];
    cocoList = [[CocoList alloc] init];
    favoritList = [[CocoList alloc] init];
    
    // helper
    dbHelper = [ModelDbHelper getInstance];
    [dbHelper assignModels:infoList
                 eventList:eventList
                notifyList:notifyList
                  cocoList:cocoList
               favoritList:favoritList];
}

-(void) reload{
    NSLog(@"reload");
    NSLog(@"%@", dbHelper);
    [dbHelper reloadInfoList];
    [dbHelper reloadEventList];
    [dbHelper reloadNotifyList];
    [dbHelper reloadCocoList];
    [dbHelper reloadFavoritList];
}

-(void) reloadInfoList{
    [dbHelper reloadInfoList];
}

-(void) reloadEventList{
    [dbHelper reloadEventList];
}

-(void) reloadNotifyList{
    [dbHelper reloadNotifyList];
}

-(void) reloadCocoList{
    [dbHelper reloadCocoList];
}

-(void) reloadFavoritList{
    [dbHelper reloadFavoritList];
}

-(Coco*) createCocoModel:(int)cocoId{
    return [dbHelper createCocoModel:cocoId];
}

-(void) updateData:(NSDictionary*) jsonDic{
    [dbHelper updateData:jsonDic];
    [[NSUserDefaults standardUserDefaults] setInteger:[[jsonDic objectForKey:@"time"] intValue] forKey:@"lastupdated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) favorit:(Coco*)coco{
    [dbHelper favorit:coco];
    coco.favorit = 1;
}

-(void) unFavorit:(Coco*)coco{
    [dbHelper unFavorit:coco];
    coco.favorit = 0;
}

@end
