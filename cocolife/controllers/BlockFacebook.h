//
//  BlockFacebook.h
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "Facebook.h"

@interface BlockFacebook : Facebook<FBSessionDelegate, FBRequestDelegate>{
    
}

-(id) initWithAppId:(NSString *)appId;
-(void) requestEvent:(NSString*)eventId;
-(void) tryAuthorize;

@end
