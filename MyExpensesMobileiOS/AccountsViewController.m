//
//  AccountsViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "AccountsViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@interface AccountsViewController()

@end

@implementation AccountsViewController

NSArray *tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableData = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].authToken];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    tableData = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].authToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"accountTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *account = [tableData objectAtIndex:indexPath.row];
    NSNumber *balance = account[@"bal"];
    
    cell.textLabel.text = account[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f €", [balance floatValue]];
    
    return cell;
}


@end
