//
//  FavoritCell.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "FavoritCell.h"

@implementation FavoritCell


-(void) initialize{
    UIColor* textColor = UIColorFromHex(0x3a1600);
    UIColor* shadowColor = UIColorFromHex(0xdda888);
    CGSize shadowOffset = CGSizeMake(0, 0.7f);
    UIColor* bgColor = [UIColor clearColor];
    UIFont* font = [UIFont boldSystemFontOfSize:12.0f];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(11.5f, 12.5f, 57, 57);
    
    thumbImageView = [[UIImageView alloc] init];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(80, 9, 215, 20);
    
    accessLabel = [[UILabel alloc] init];
    accessLabel.frame = CGRectMake(97, 28, 200, 20);
    
    excerptView = [[UILabel alloc] init];
    excerptView.frame = CGRectMake(80, 55, 210, 20);
    excerptView.numberOfLines = 1;
    
    titleLabel.textColor = excerptView.textColor = accessLabel.textColor = textColor;
    titleLabel.backgroundColor = excerptView.backgroundColor = accessLabel.backgroundColor= bgColor;
    titleLabel.shadowColor = excerptView.shadowColor = accessLabel.shadowColor = shadowColor;
    titleLabel.shadowOffset = excerptView.shadowOffset = accessLabel.shadowOffset = shadowOffset;
    accessLabel.font = font;
    excerptView.textColor = UIColorFromHex(0x471d04);
    excerptView.font = [UIFont boldSystemFontOfSize:11.0f];
    excerptView.shadowOffset = CGSizeMake(0, 0.4f);
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    [self addSubview:indicator];
    [self addSubview:thumbImageView];
    [self addSubview:titleLabel];
    [self addSubview:accessLabel];
    [self addSubview:excerptView];
}

-(void) update{
    [super update];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, coco.thumbImage];
    [ImageCache loadImage:requestUrl callback:^(UIImage *image, NSString *key) {
        if(![key isEqualToString:requestUrl]){
            return ;
        }
        image = [Utils scaledImageWithImage:image]; // scale
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbImageView.image = image;
            thumbImageView.frame = CGRectMake(11.5f, 12.5f, 57, 57);
        });
    }];
}


@end
