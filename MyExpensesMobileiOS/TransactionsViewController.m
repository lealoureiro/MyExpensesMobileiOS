//
//  SecondViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "TransactionsViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController

NSArray *accountList;
NSArray *transactionsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountChooser.dataSource = self;
    self.accountChooser.delegate = self;
    accountList = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey];
    NSString *account = [accountList objectAtIndex:0][@"id"];
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:account withApiKey:[ApplicationState getInstance].apiKey];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return accountList.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *account = [accountList objectAtIndex:row];
    return account[@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Selected account %ld to view transactions", row);
    NSString *account = [accountList objectAtIndex:row][@"id"];
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:account withApiKey:[ApplicationState getInstance].apiKey];
    [self.transactionsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"accountTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewStylePlain;
    }
    
    NSDictionary *account = [transactionsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = account[@"description"];
    
    return cell;
}



@end
