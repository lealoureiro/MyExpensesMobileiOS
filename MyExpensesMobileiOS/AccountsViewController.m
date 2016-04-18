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
#import "TransactionsViewController.h"

@interface AccountsViewController()

@end

@implementation AccountsViewController

NSArray *tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Accounts"];
    tableData = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"accountEntry";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *account = [tableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = account[@"name"];
    cell.detailTextLabel.text = account[@"type"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row %ld selected", indexPath.row);
     [self performSegueWithIdentifier:@"goToAccount" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToAccount"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TransactionsViewController *destViewController = segue.destinationViewController;
        destViewController.account = [tableData objectAtIndex:indexPath.row];
    }
}


@end
