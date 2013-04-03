//
//  FbUser.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "FbEventUser.h"

#define IMAGE_URL @"https://graph.facebook.com/%@/picture?type=large"

@implementation FbEventUser

@synthesize userId;
@synthesize name;
@synthesize rsvpStatus;
@synthesize message;

-(id) initWithDictionary:(NSDictionary*)dic{
    self = [super init];
    if(self){
        userId = [dic objectForKey:@"id"];
        name = [dic objectForKey:@"name"];
        message = [dic objectForKey:@"message"];
        rsvpStatus = [dic objectForKey:@"rsvp_status"];
    }
    
    return self;
}

-(BOOL)hasMessage{
    return (message != nil);
}

-(void) setCommentList:(FbEventUserList *)commentList_{
    commentList = commentList_;
}

-(FbEventUserList*)getCommentList{
    return commentList; // TODO clone?
}

-(NSString*)imageUrl{
    return [NSString stringWithFormat:IMAGE_URL, userId];
}

@end
