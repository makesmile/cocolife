//
//  ListViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

-(BOOL) useAllDisplay{
    return YES;
}

-(void) setNaviTitle{
    UIImageView* titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listTitle"]];
    self.navigationItem.titleView = titleImage;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.0f;
}

-(UIColor*) createBgColor:(int)index{
    int imageIndex = (index % 4) + 1;
    
    if(index == [cocoList count]-1){
        return [UIColor colorWithPatternImage:[UIImage imageNamed:@"listCellBgLast"]];
    }
    
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"listCellBg%d", imageIndex]]];
}

-(UIColor*)createSelectedBgColor:(int)index{
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"listCellBgOn"]];
}

-(AbstractCocoCell*)createCell:(UITableView *)tableView CellIdentifier:(NSString *)CellIdentifier{
    ListCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}


@end
