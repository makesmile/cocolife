//
//  FbUser.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractModel.h"
@class FbEventUserList;
@interface FbEventUser : AbstractModel{
    NSString* userId;
    NSString* name;
    NSString* rsvpStatus;
    NSString* message;
    FbEventUserList* commentList;
}

-(id) initWithDictionary:(NSDictionary*)dic;

@property NSString* userId;
@property NSString* name;
@property NSString* rsvpStatus;
@property NSString* message;

-(BOOL) hasMessage;
-(void) setCommentList:(FbEventUserList*)commentList_;
-(FbEventUserList*) getCommentList;
-(NSString*)imageUrl;

@end
