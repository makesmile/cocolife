//
//  DbHelper.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMBaseDb.h"
#import "InfoList.h"
#import "EventList.h"
#import "NotifyList.h"
#import "CocoList.h"


@interface ModelDbHelper : NSObject{    
    InfoList* infoList;
    EventList* eventList;
    NotifyList* notifyList;
    CocoList* cocoList;
    CocoList* favoritList;
}

+(ModelDbHelper*)getInstance;

// ▼ データソースがDB以外に増えるようなら抽象化

-(id) assignModels:(InfoList*)infoList_
         eventList:(EventList*)eventList_
        notifyList:(NotifyList*) notifyList_
          cocoList:(CocoList*)cocoList_
       favoritList:(CocoList*)favoritList_;

-(void) createTable;

-(void) reloadInfoList;
-(void) reloadEventList;
-(void) reloadNotifyList;
-(void) reloadCocoList;
-(void) reloadFavoritList;
-(Coco*) createCocoModel:(int)cocoId;
-(void) updateData:(NSDictionary*) jsonDic;
-(void) favorit:(Coco*)coco;
-(void) unFavorit:(Coco*)coco;

@end