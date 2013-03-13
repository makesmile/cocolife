//
//  FavoritViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/13.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "FavoritViewController.h"

@interface FavoritViewController ()

@end

@implementation FavoritViewController

@synthesize onDeleteFavorit;
@synthesize onEditMode;
@synthesize onNormalMode;

-(void) initialize{
    [super initialize];
    CGRect frame = [self viewFrame];
    frame.size.height += 50.25f;
    tableView_.frame = frame;
    [self normalMode];
}

-(void) setNaviTitle{
    UIImageView* titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favoritTitle"]];
    self.navigationItem.titleView = titleImage;
}

-(void) toEditMode{
    [tableView_ setEditing:YES animated:YES];
    UIButton *editView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 29.5f)];
    [editView setBackgroundImage:[UIImage imageNamed:@"naviDoneButton"]
                        forState:UIControlStateNormal];
    [editView addTarget:self action:@selector(toNormalMode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView:editView];
    self.navigationItem.leftBarButtonItem = menuButton;
    if(onEditMode)
        onEditMode();
//    [callbackObject showLeftAll];
}

-(void) toNormalMode{
    [tableView_ setEditing:NO animated:YES];
    UIButton *editView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 29.5f)];
    [editView setBackgroundImage:[UIImage imageNamed:@"naviEditButton"]
                        forState:UIControlStateNormal];
    [editView addTarget:self action:@selector(toEditMode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView:editView];
    self.navigationItem.leftBarButtonItem = menuButton;
    if(onNormalMode)
        onNormalMode();
}

-(void) normalMode{
    [tableView_ setEditing:NO animated:YES];
    UIButton *editView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 29.5f)];
    [editView setBackgroundImage:[UIImage imageNamed:@"naviEditButton"]
                        forState:UIControlStateNormal];
    [editView addTarget:self action:@selector(toEditMode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView:editView];
    self.navigationItem.leftBarButtonItem = menuButton;
}

// ▼ UITableViewDelegate ======================================

// Override
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [cocoList count]-1){
        return 82.0f;
    }
    return 80.0f;
}
// Override
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView_ deselectRowAtIndexPath:[tableView_ indexPathForSelectedRow] animated:YES];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(AbstractCocoCell*)createCell:(UITableView *)tableView CellIdentifier:(NSString *)CellIdentifier{
    return [[FavoritCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
}

-(UIColor*) createBgColor:(int)index{
    if(index == [cocoList count]-1)
        return [UIColor colorWithPatternImage:[UIImage imageNamed:@"favoritCellBgLast"]];
    
    int imageIndex = (index % 5) + 1;
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"favoritCellBg%d", imageIndex]]];
}

-(UIColor*) createSelectedBgColor:(int)index{
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"favoritCellBgOn"]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int index = [indexPath row];
        Coco* coco = (Coco*)[cocoList get:index];
        [cocoList deleteItem:coco.id_];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
        if(onDeleteFavorit)
            onDeleteFavorit(coco);
    }
}


@end
