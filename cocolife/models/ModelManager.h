//
//  ModelManager.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDbHelper.h"
#import "CocoList.h"
#import "EventList.h"
#import "InfoList.h"
#import "NotifyList.h"

@interface ModelManager : NSObject{
    ModelDbHelper* dbHelper;
    InfoList* infoList;
    EventList* eventList;
    NotifyList* notifyList;
    CocoList* cocoList;
    CocoList* favoritList;
}

@property (readonly) InfoList* infoList;
@property (readonly) EventList* eventList;
@property (readonly) NotifyList* notifyList;
@property (readonly) CocoList* cocoList;
@property (readonly) CocoList* favoritList;

+(ModelManager*)getInstance;

-(void) reload;
-(void) reloadInfoList;
-(void) reloadEventList;
-(void) reloadNotifyList;
-(void) reloadCocoList;
-(void) reloadFavoritList;
-(void) updateData:(NSDictionary*) jsonDic;
-(Coco*) createCocoModel:(int)cocoId;
-(void) favorit:(Coco*)coco;
-(void) unFavorit:(Coco*)coco;

@end
