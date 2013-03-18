//
//  ListCell.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

-(void) initialize{
    UIColor* textColor = UIColorFromHex(0x3a1600);
    UIColor* shadowColor = UIColorFromHex(0xdda888);
    CGSize shadowOffset = CGSizeMake(0, 0.7f);
    UIColor* bgColor = [UIColor clearColor];
    UIFont* font = [UIFont boldSystemFontOfSize:12.0f];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(13.5f, 14.5f, 80, 80);
    
    thumbImageView = [[UIImageView alloc] init];
    
    newIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellNewIcon"]];
    newIconView.frame = CGRectMake(15.0f, 8.0f, 25.0f, 29.0f);
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(105, 9, 215, 20);
    
    accessLabel = [[UILabel alloc] init];
    accessLabel.frame = CGRectMake(125, 30, 180, 20);
    
    excerptView = [[UILabel alloc] init];
    excerptView.frame = CGRectMake(105, 47, 190, 55);
    excerptView.numberOfLines = 3;
    
    titleLabel.textColor = excerptView.textColor = accessLabel.textColor = textColor;
    titleLabel.backgroundColor = excerptView.backgroundColor = accessLabel.backgroundColor= bgColor;
    titleLabel.shadowColor = excerptView.shadowColor = accessLabel.shadowColor = shadowColor;
    titleLabel.shadowOffset = excerptView.shadowOffset = accessLabel.shadowOffset = shadowOffset;
    accessLabel.font = font;
    excerptView.textColor = UIColorFromHex(0x3a1600);
    excerptView.font = [UIFont boldSystemFontOfSize:11.0f];
    excerptView.shadowOffset = CGSizeMake(0, 0.4f);
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    //    [self addSubview:thumbBgView];
    [self addSubview:indicator];
    [self addSubview:thumbImageView];
    [self addSubview:newIconView];
    [self addSubview:titleLabel];
    [self addSubview:accessLabel];
    [self addSubview:excerptView];
}

// ▼ Override ====================================

-(void) update{
    [super update];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, coco.thumbImage];
    [ImageCache loadImage:requestUrl callback:^(UIImage *image, NSString *key) {
        if(![key isEqualToString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, coco.thumbImage]]){
            return ;
        }
        image = [Utils scaledImageWithImage:image]; // scale
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbImageView.image = image;
            thumbImageView.frame = CGRectMake(13.5f, 14.5f, 80, 80);
        });
    }];
}



@end
