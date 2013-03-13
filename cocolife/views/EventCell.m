//
//  EventCell.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize{
    [self setLabels];
    [self setImageView];
    [self setIcons];
}

-(void) setIcons{
    calIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fbCalIcon"]];
    pinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fbPinIcon"]];
    newIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellNewIcon"]];
    calIcon.frame = CGRectMake(105.0f, 32.0f, 19.0f, 16.0f);
    pinIcon.frame = CGRectMake(107.5f, 50.0f, 14.0f, 19.0f);
    newIcon.frame = CGRectMake(15.0f, 8.0f, 25.0f, 29.0f);
    [self addSubview:calIcon];
    [self addSubview:pinIcon];
    [self addSubview:newIcon];
}

-(void) setImageView{
    CGRect imageFrame = CGRectMake(13.2f, 16.2f, 78.0f, 78.0f);
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = imageFrame;
    imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    
    [self addSubview:indicator];
    [self addSubview:imageView];
}

-(void) setLabels{
    UIColor* textColor = UIColorFromHex(0x3a1600);
    UIColor* shadowColor = UIColorFromHex(0xdda888);
    CGSize shadowOffset = CGSizeMake(0, 0.7f);
    UIColor* bgColor = [UIColor clearColor];
    UIFont* font = [UIFont boldSystemFontOfSize:12.0f];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(105.0f, 12.0f, 195.0f, 18.0f)];
    period = [[UILabel alloc] initWithFrame:CGRectMake(127.0f, 32.0f, 175.0f, 16.0f)];
    access = [[UILabel alloc] initWithFrame:CGRectMake(127.0f, 50.0f, 175.0f, 19.0f)];
    excerpt = [[UILabel alloc] initWithFrame:CGRectMake(105.0f, 70.0f, 195.0f, 30.0f)];
    excerpt.numberOfLines = 2;
    
    name.textColor = period.textColor = access.textColor = excerpt.textColor = textColor;
    name.backgroundColor = period.backgroundColor = access.backgroundColor = excerpt.backgroundColor = bgColor;
    name.shadowColor = period.shadowColor = access.shadowColor = excerpt.shadowColor = shadowColor;
    name.shadowOffset = period.shadowOffset = access.shadowOffset = excerpt.shadowOffset = shadowOffset;
    period.font = access.font = excerpt.font = font;
    name.font = [UIFont boldSystemFontOfSize:14.5f];
    
    [self addSubview:name];
    [self addSubview:period];
    [self addSubview:access];
    [self addSubview:excerpt];
}

-(void) loadImage:(NSString*)imageUrl{
    imageView.image = nil;
    // 画像なし
    if([imageUrl isEqualToString:@""] || imageUrl == nil){
        return;
    }
    
    [ImageCache loadImage:event.image callback:^(UIImage *image, NSString *key) {
        if(![event.image isEqualToString:key]) return;
        CGSize imageSize = image.size;
        UIImage* clipImage;
        if(imageSize.width > imageSize.height){
            clipImage = [Utils clipImage:image rect:CGRectMake(0, 0, imageSize.height, imageSize.height)];
        }else{
            clipImage = [Utils clipImage:image rect:CGRectMake(0, 0, imageSize.width, imageSize.width)];
        }
        UIImage* scaledImage = [Utils getResizedImage:clipImage width:78 height:78];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:scaledImage];
            imageView.frame = CGRectMake(13.2f, 16.2f, scaledImage.size.width, scaledImage.size.height);
        });
    }];
    
}

// ▼ public =====================================

-(void) setModel:(Event*)event_{
    event = event_;
}

-(void) update{
    imageView.image = nil;
    [indicator startAnimating];
    name.text = event.name;
    if([[event getStartTimeString] isEqualToString:[event getEndTimeString]] /* TODO この条件はモデルに入れちゃうか? */){
        period.text = [event getStartTimeString];
    }else{
        period.text = [NSString stringWithFormat:@"%@〜%@", [event getStartTimeString], [event getEndTimeString]];
    }
    access.text = event.station /* event.address*/ /*event.location*/;
    excerpt.text = event.description;
    newIcon.hidden = ![event isNew];
    
    [self loadImage:event.image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end