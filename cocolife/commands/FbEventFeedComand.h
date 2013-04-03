//
//  FbEventFeedComand.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCommand.h"
#import "URLLoadCommand.h"
#import "FbEventUserList.h"

typedef void (^onLoad_t)(FbEventUserList* userList);
typedef void (^onFail_t)(NSError* error);

@interface FbEventFeedComand : AbstractCommand{
    NSString* eventId;
    
    onLoad_t onLoad;
    onFail_t onFail;
}

@property (strong) onLoad_t onLoad;
@property (strong) onFail_t onFail;

-(id) initWithEventId:(NSString*)eventId_;

@end
