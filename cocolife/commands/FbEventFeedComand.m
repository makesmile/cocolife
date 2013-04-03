//
//  FbEventFeedComand.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "FbEventFeedComand.h"
#define FEED_API_URL @"http://api.makesmile.jp/cocosearch/eventFeed.php?eventId=%@"

@implementation FbEventFeedComand

@synthesize onLoad;
@synthesize onFail;

-(id) initWithEventId:(NSString*)eventId_{
    self = [super init];
    if(self){
        eventId = eventId_;
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    
}

-(void) internalExecute:(NSObject *)data{
    NSString* requestUrl = [NSString stringWithFormat:FEED_API_URL, eventId];
    URLLoadCommand* urlLoadCommand = [[URLLoadCommand alloc] initWithUrl:requestUrl];
    [urlLoadCommand setOnError:^(URLLoadOperation *operation, NSError *error) {
        if(onFail)
            onFail(error);
    }];
    [urlLoadCommand setOnFinished:^(URLLoadOperation *operation, NSData *data) {
        NSError *error = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:(NSData*)data options:NSJSONReadingAllowFragments error:&error];
        if(error != nil){
            NSLog(@"%@", error.debugDescription);
            return;
        }
        
        FbEventUserList* userList = [self createModel:jsonArray];
        if(onLoad)
            onLoad(userList);
     
        [self onComplete:nil];
    }];
    
    [urlLoadCommand execute:nil];
}

-(FbEventUserList*)createModel:(NSArray*)jsonArray{
    FbEventUserList* list = [[FbEventUserList alloc] init];
    
    for(int i=0,max=[jsonArray count];i<max;i++){
        NSDictionary* row = [jsonArray objectAtIndex:i];
        FbEventUser* user = [[FbEventUser alloc] initWithDictionary:row];
        FbEventUserList* commentUserList = [[FbEventUserList alloc] init];
        NSArray* commentData = [[row objectForKey:@"comments"] objectForKey:@"data"];
        for(int j=0,jMax=[commentData count];j<jMax;j++){
            NSDictionary* jRow = [commentData objectAtIndex:j];
            NSDictionary* from = [jRow objectForKey:@"from"];
            FbEventUser* commentUser = [[FbEventUser alloc] init];
            commentUser.userId = [from objectForKey:@"id"];
            commentUser.name = [from objectForKey:@"name"];
            commentUser.message = [jRow objectForKey:@"message"];
            [commentUserList add:commentUser];
        }
        
        [user setCommentList:commentUserList];
        [list add:user];
    }
    
    return list;
}

@end
