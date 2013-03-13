//
//  MapPaperView.m
//  cocosearch
//
//  Created by yu kawase on 12/12/26.
//  Copyright (c) 2012年 cocosearch. All rights reserved.
//

#import "MapPaperView.h"
#define IMAGE_URL @"http://img.makesmile.jp/cocosearch/"

@implementation MapPaperView

@synthesize onPaperTap;

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    [self setViews];
}

-(void) setViews{

    UIButton* bgImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgImageButton.frame = CGRectMake(2.0f, 0, 311, 137.5f);
    [bgImageButton setImage:[UIImage imageNamed:@"mapPaper"] forState:UIControlStateNormal];
    [bgImageButton addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
    self.frame = bgImageButton.frame;
    [self addSubview:bgImageButton];
    
    // image
    imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
     UIColor* textColor = UIColorFromHex(0x471d04);
    // name
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 180, 15)];
    nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self addSubview:nameLabel];
    
    // station
    stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 24, 195, 15)];
    stationLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:stationLabel];
    
    // description
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 47, 210, 15)];
    descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:descriptionLabel];
    
    nameLabel.textColor = stationLabel.textColor = descriptionLabel.textColor = textColor;
    nameLabel.backgroundColor = stationLabel.backgroundColor = descriptionLabel.backgroundColor = [UIColor clearColor];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGesTap)]];
}

-(void) onGesTap{
    NSLog(@"onGesTap");
    if(onPaperTap)
        onPaperTap(coco);
}

-(void) onTap{
    NSLog(@"onTap");
    if(onPaperTap)
        onPaperTap(coco);
}

// TODO この関数もどっかにまとめないとな
-(void) loadImage:(NSString*)imageUrl{
    imageView.image = nil;
    // 画像なし
    if([imageUrl isEqualToString:@""]){
        return;
    }
    
    UIImage* image = [ImageCache getChache:imageUrl];
    if(image){
        UIImage* scaledImage = [Utils getResizedImage:image width:57 height:57];
        [imageView setImage:scaledImage];
        imageView.frame = CGRectMake(10.0f, 7.9f, scaledImage.size.width, scaledImage.size.height);
        return;
    }
    
    // TODO imageDic(キャッシュはどっかで消さないとやばい)
    image = [[UIImage alloc] init];
    [ImageCache setCache:image forKey:imageUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString* requestUrl = [NSString stringWithFormat:@"%@%@", IMAGE_URL, imageUrl];
        UIImage* image = [Utils scaledImageWithImage:
                          [UIImage imageWithData:
                           [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl]]]];
        if(image == nil){
            return;
        }
        [ImageCache setCache:image forKey:imageUrl];
        if(imageUrl != coco.thumbImage){
            return;
        }
        UIImage* scaledImage = [Utils getResizedImage:image width:57 height:57];
        // UIの更新はメインスレッド
        dispatch_sync(dispatch_get_main_queue(), ^{
            [imageView setImage:scaledImage];
            imageView.frame = CGRectMake(10.0f, 7.9f, scaledImage.size.width, scaledImage.size.height);
        });
    });
}

// ▼ public ==========================

-(void) setModel:(Coco*)coco_{
    coco = coco_;
}

-(void) update{
    nameLabel.text = coco.name;
    stationLabel.text = coco.station;
    descriptionLabel.text = coco.excerpt;
    [self loadImage:coco.thumbImage];
}

@end
