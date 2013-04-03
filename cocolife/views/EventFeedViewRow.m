//
//  EventFeedViewRow.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "EventFeedViewRow.h"

@implementation EventFeedImage

@synthesize onTapUser;

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    CGRect frame = CGRectMake(0, 0, 58, 58);
    
    // indiator
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = frame;
    
    // image
    imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    imageButton.frame = frame;
    
    hukidasiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hukidashi"]];
    hukidasiView.hidden = YES;
    hukidasiView.userInteractionEnabled = NO;
    hukidasiView.frame = CGRectMake(5, 5, 20.5f, 17.5f);
    
    [self addSubview:indicator];
    [self addSubview:imageButton];
    [self addSubview:hukidasiView];
    self.frame = frame;
    self.backgroundColor = UIColorFromHex(0xe0c8a3);
}

-(void) tap:(UIButton*)button{
    if(onTapUser)
        onTapUser(self, user);
}

-(void) setModel:(FbEventUser*)user_{
    user = user_;
}

-(void) update{
    [indicator startAnimating];
    [ImageCache loadImage:user.imageUrl callback:^(UIImage *image, NSString *key) {
        CGSize imageSize = image.size;
        float base = (imageSize.width > imageSize.height) ? imageSize.height : imageSize.width;
        UIImage* clipedImage = [Utils clipImage:image rect:CGRectMake(0, 0, base, base)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageButton setImage:clipedImage forState:UIControlStateNormal];
            hukidasiView.hidden = ![user hasMessage];
        });
    }];
}

-(void) hide{
    
}

@end

@implementation EventFeedViewRow

@synthesize openRow;
@synthesize originalFrame;

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    viewList = [[NSMutableArray alloc] init];
    eventTalkView = [[EventTalkView alloc] init];
    [self addSubview:eventTalkView];
}

-(void)reset{
    [eventTalkView reset];
}

-(void) setModel:(FbEventUserList*)userList_ offset:(int)offset_{
    userList = userList_;
    offset = offset_;
    
    [eventTalkView reset];
    
    CGRect frame = CGRectMake(10, 10, 58, 58);
    float margin = 9.5f;
    
    onTapUser_t onTapUser = ^(UIView* view, FbEventUser* user){
        [eventTalkView setModel:user];
        [eventTalkView update];
        float x = view.frame.origin.x + 20;
        [eventTalkView  arrowX:x];
        float height = eventTalkView.frame.size.height;
        if(openRow)
            openRow(self, height);
    };
    
    int max = (offset + 4 > [userList count]) ? [userList count] : offset + 4;
    for(int i=offset;i<max;i++){
        FbEventUser* user = (FbEventUser*)[userList get:i];
        EventFeedImage* view = [[EventFeedImage alloc] init];
        view.onTapUser = onTapUser;
        [view setModel:user];
        view.frame = frame;
        frame.origin.x += frame.size.width + margin;
        [self addSubview:view];
        [viewList addObject:view];
    }
}

-(void) update{
    for(int i=0,max=[viewList count];i<max;i++){
        EventFeedImage* view = (EventFeedImage*)[viewList objectAtIndex:i];
        [view update];
    }
}


-(float) talkHeight{
    return eventTalkView.frame.size.height;
}

@end
