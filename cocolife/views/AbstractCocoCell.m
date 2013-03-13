//
//  AbstractCocoCell.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoCell.h"

@implementation AbstractCocoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize{}


// ▼ public ==========================

-(void) setModel:(Coco*)coco_{
    coco = coco_;
}

-(void) update{
    thumbImageView.image = nil;
    [indicator startAnimating];
    titleLabel.text = coco.name;
    excerptView.text = coco.excerpt;
    accessLabel.text = coco.station;
    
    // TODO 新しければ
    newIconView.hidden = /*!([coco.created intValue] > 1339047250)*/ ![coco isNew];
    if(coco.thumbImage != nil){
        
    }else{
        
    }
}


@end
