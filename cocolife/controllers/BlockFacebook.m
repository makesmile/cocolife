//
//  BlockFacebook.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "BlockFacebook.h"

@implementation BlockFacebook

-(id) initWithAppId:(NSString *)appId{
    self = [super initWithAppId:appId andDelegate:self];
    if(self){
        [self extendAccessTokenIfNeeded];
    }
    
    return self;
}

-(void) tryAuthorize{
    NSArray *permissions = [NSArray arrayWithObjects:@"user_about_me",
                            @"publish_stream",nil];
    [self authorize:permissions];
    
}

-(void) requestEvent:(NSString*)eventId{
    NSString* type = @"feed";
    type = @"events";
    eventId = @"126459367423393";
    NSString* path = [NSString stringWithFormat:@"%@/%@", eventId, type];
    [self requestWithGraphPath:path andDelegate:self];
    
}

// ▼ FBRequestDelegate =============================

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request{
    NSLog(@"requestLoading");
}

/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveResponse");
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", error.debugDescription);
    NSLog(@"didFailWithError");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result{
    NSLog(@"didLoad");
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data{
    NSLog(@"didLoadRawResponse");
    
}

// ▼ FBSessionDelegate =============================

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin{
    
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled{
    
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    NSLog(@"fbDidExtendToken");
    NSLog(@"%@", accessToken);
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout{
    
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated{
    
}

@end
