//
//  TopViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

@synthesize onSelectEvent;
@synthesize onSelectInfo;
@synthesize onLeftToggle;

-(void) initialize{
    [super initialize];
    [self setViews];
    [self setNaviTitle];
    [self setNaviButton];
}

-(BOOL) useAllDisplay{
    return YES;
}

-(void) setViews{
    infoSlide = [[InfoSlideCellView alloc] init];
    infoSlide.onTapInfo = ^(Info* info){
        if(onSelectInfo)
            onSelectInfo(self, info);
    };
    
    tableView_ = [[UITableView alloc] initWithFrame:[self viewFrame] style:UITableViewStylePlain];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self.view addSubview:tableView_];
}

-(void) setNaviTitle{
    UIImageView* titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topTitle"]];
    self.navigationItem.titleView = titleImage;
}

-(void) setNaviButton{
    // お気に入りボタン
    UIButton *favoritButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoritButton.frame = CGRectMake(0, 0, 35, 33.5f);
    [favoritButton setBackgroundImage:[UIImage imageNamed:@"favoritButton"] forState:UIControlStateNormal];
    [favoritButton addTarget:self action:@selector(leftToggle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barBackButton = [[UIBarButtonItem alloc]initWithCustomView:favoritButton];
    self.navigationItem.leftBarButtonItem = barBackButton;
}

-(void) leftToggle{
    if(onLeftToggle)
        onLeftToggle();
}

// ▼ public ===========================

-(void) assignModel:(InfoList*)infoList_ eventList:(EventList*)eventList_{
    infoList = infoList_;
    eventList = eventList_;
    
    [infoSlide assignModel:infoList_];
}

-(void) update{
    [tableView_ reloadData];
    [infoSlide update];
}

-(void) toTop{
    tableView_.contentOffset = CGPointMake(0, 0);
}

// ▼ tableViewDelegate ================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 10;
    return [eventList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return infoSlide;
    }
    
    static NSString *CellIdentifier = @"ItemCell";
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Event* event = (Event*)[eventList get:indexPath.row-1];
    [cell setModel:event];
    [cell update];
    
    return cell;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 176.5f;
    }
    return 107.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event* event = (Event*)[eventList get:indexPath.row-1];
    
    if(onSelectEvent)
        onSelectEvent(self, event);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newsBg"]];
        return;
    }
    
    int index = ((indexPath.row-1) % 2) + 1;
    index = 1; // TODO トリアエズ
    if(indexPath.row == [eventList count]){
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fbCellBgLast"]];
    }else{
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"fbCellBg%d", index]]];
    }
    
    UIColor* selectedCol = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"fbCellBgOn"]];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:selectedCol];
    [cell setSelectedBackgroundView:bgView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ハイライト解除
    [tableView_ deselectRowAtIndexPath:[tableView_ indexPathForSelectedRow] animated:YES];
}


@end
