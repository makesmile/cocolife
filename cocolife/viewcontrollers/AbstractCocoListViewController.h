//
//  AbstractCocoListViewController.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoViewController.h"
#import "CocoList.h"
#import "AbstractCocoCell.h"

@interface AbstractCocoListViewController : AbstractCocoViewController<
UITableViewDataSource
, UITableViewDataSource
>{
    // models
    CocoList* cocoList;
    
    // views
    UITableView* tableView_;
}

-(void) setNaviTitle;
-(void) assignModel:(CocoList*)cocoList_;
-(void) update;
-(void) toTop;

// abstract
-(AbstractCocoCell*)createCell:(UITableView*)tableView CellIdentifier:(NSString*)CellIdentifier;
-(UIColor*) createBgColor:(int)index;
-(UIColor*) createSelectedBgColor:(int)index;
-(void) setNaviTitle;

// TODO 子からよびたい、なぜか宣言がひつよう
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
