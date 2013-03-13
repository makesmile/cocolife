//
//  FavoritViewController.h
//  cocolife
//
//  Created by yu kawase on 13/03/13.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoListViewController.h"
#import "FavoritCell.h"

typedef void(^onDeleteFavorit_t)(Coco* coco);
typedef void(^onEditMode_t)();
typedef void(^onNormalMode_t)();

@interface FavoritViewController : AbstractCocoListViewController{
    // callback
    onDeleteFavorit_t onDeleteFavorit;
    onEditMode_t onEditMode;
    onNormalMode_t onNormalMode;
}

@property (strong) onDeleteFavorit_t onDeleteFavorit;
@property (strong) onEditMode_t onEditMode;
@property (strong) onNormalMode_t onNormalMode;

@end
