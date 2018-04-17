//
//  UITableView+UI.m
//  ksh3
//
//  Created by songlin on 06/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UITableView+UI.h"

@implementation UITableView (UI)

+ (instancetype)configureTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = NO;
    return tableView;
}

+ (instancetype)configureTableViewWithFrame:(CGRect)frame{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = NO;
    return tableView;

}
@end
