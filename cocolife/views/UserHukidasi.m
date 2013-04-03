//
//  UserHukidasi.m
//  cocolife
//
//  Created by yu kawase on 13/03/27.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "UserHukidasi.h"

// http://stackoverflow.com/questions/3760924/set-line-height-in-uitextview
@interface UITextView ()
- (id)styleString; // make compiler happy
@end

@interface MBTextView : UITextView
@end
@implementation MBTextView
- (id)styleString {
    return [[super styleString] stringByAppendingString:@"; line-height: 1.3em"];
}
@end

@implementation UserHukidasi

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    imageView = [[UIImageView alloc] init];
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    messageView = [[MBTextView alloc] init];
    messageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hukidasiLarge"]];

    nameLabel.textColor = UIColorFromHex(0xa38351);
    messageBg.contentStretch = CGRectMake(0, 0.5f, 1.0f, 0.1f);
    messageView.backgroundColor = nameLabel.backgroundColor = [UIColor clearColor];
    messageView.textColor = UIColorFromHex(0xa38351);
    
    [self addSubview:imageView];
    [self addSubview:nameLabel];
    [self addSubview:messageBg];
    [self addSubview:messageView];
}

-(void) setModel:(FbEventUser*)user_ index:(int)index_{
    user = user_;
    index = index_;
    nameLabel.text = user.name;
    
    messageView.frame = CGRectMake(57, 30, 210, 5000);
    messageView.text = (user.message == nil || [user.message isEqualToString:@""]) ? @"no comment." : user.message;
    [messageView sizeToFit];
}

-(void) update{
    if(index%2 == 0){
        imageView.frame = CGRectMake(280-42-10+1, 10, 42, 42);
        nameLabel.frame = CGRectMake(10, 6, 210, 20);
        nameLabel.textAlignment = UITextAlignmentRight;
        CGRect messageFrame = messageView.frame;
        messageFrame.origin.x = 10;
        messageFrame.size.width += 5;
        messageView.frame = messageFrame;
        messageBg.frame = messageView.frame;
        messageBg.transform = CGAffineTransformScale(messageBg.transform, -1, 1);
    }else{
        imageView.frame = CGRectMake(10, 10, 42, 42);
        nameLabel.frame = CGRectMake(62, 6, 200, 20);
        CGRect messageFrame = messageView.frame;
        messageFrame.origin.x += 5;
        messageView.frame = messageFrame;
        messageFrame.origin.x -= 5;
        messageFrame.size.width += 5;
        messageBg.frame = messageFrame;
    }
    
    [ImageCache loadImage:user.imageUrl callback:^(UIImage *image, NSString *key) {
        CGSize imageSize = image.size;
        float base = (imageSize.width > imageSize.height) ? imageSize.height : imageSize.width;
        UIImage* clipedImage = [Utils clipImage:image rect:CGRectMake(0, 0, base, base)];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = clipedImage;
        });
    }];
    
    float height = messageView.frame.origin.y + messageView.frame.size.height;
    self.frame = CGRectMake(0, 0, 280, height);
}

-(float) setY:(float)y{
    CGRect currentFrame = self.frame;
    currentFrame.origin.y = y;
    self.frame = currentFrame;
    return currentFrame.size.height + y;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
