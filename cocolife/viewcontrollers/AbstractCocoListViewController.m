//
//  AbstractCocoListViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "AbstractCocoListViewController.h"

@interface AbstractCocoListViewController ()

@end

@implementation AbstractCocoListViewController


-(void) initialize{
    [super initialize];

    tableView_ = [[UITableView alloc] initWithFrame:[self viewFrame] style:UITableViewStylePlain];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self setNaviTitle];
    
    [self.view addSubview:tableView_];
}

// ▼ TableViewDelegate ================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cocoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    AbstractCocoCell* cell = [self createCell:tableView CellIdentifier:CellIdentifier];
    
    Coco* coco = (Coco*)[cocoList get:indexPath.row];
    [cell setModel:coco];
    [cell update];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self createBgColor:indexPath.row];
    
    UIColor* selectedCol = [self createSelectedBgColor:indexPath.row];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:selectedCol];
    [cell setSelectedBackgroundView:bgView];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Coco* coco = (Coco*)[cocoList get:indexPath.row];
    if(onSelectCoco)
        onSelectCoco(self, coco);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ハイライト解除
    [tableView_ deselectRowAtIndexPath:[tableView_ indexPathForSelectedRow] animated:YES];
    
    float sa = tableView_.contentSize.height - tableView_.contentOffset.y - tableView_.frame.size.height;
    if(sa <= 10){
        tableView_.contentOffset = CGPointMake(0, tableView_.contentOffset.y - 30);
    }
}

// ▼ abstract ==============================

-(void) setNaviTitle{}

// ▼ public ================================

-(void) assignModel:(CocoList*)cocoList_{
    cocoList = cocoList_;
}

-(void) update{
    [tableView_ reloadData];
}

-(void) toTop{
    tableView_.contentOffset = CGPointMake(0, 0);
}

// abstract
-(AbstractCocoCell*)createCell:(UITableView*)tableView CellIdentifier:(NSString*)CellIdentifier{
    return nil;
}

// abstract
-(UIColor*) createBgColor:(int)index{
    return nil;
}
-(UIColor*) createSelectedBgColor:(int)index{
    return nil;
}

@end
