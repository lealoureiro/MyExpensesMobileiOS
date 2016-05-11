//
//  AddExpenseFormTableViewController.m
//  MyExpense
//
//  Created by Leandro Loureiro on 28/04/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "NewTransactionFormViewController.h"
#import "TransactionDescriptionTableViewCell.h"
#import "TransactionAmountTableViewCell.h"
#import "TransactionTypeCell.h"
#import "SelectionCell.h"
#import "ListSelectorViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@interface NewTransactionFormViewController ()

@end

@implementation NewTransactionFormViewController

TransactionDescriptionTableViewCell *transactionDescriptionCell;
TransactionAmountTableViewCell *transactionAmountCell;
TransactionTypeCell *transactionTypeCell;
SelectionCell *accountCell;
SelectionCell *categoryCell;
SelectionCell *subCategoryCell;

NSArray *accounts;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Transaction";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    transactionDescriptionCell = [[TransactionDescriptionTableViewCell alloc] initWithIdentifier:@"descriptionCell"];
    transactionAmountCell = [[TransactionAmountTableViewCell alloc] initWithIdentifier:@"amountCell"];
    transactionTypeCell = [[TransactionTypeCell alloc] initWithIdentifier:@"typeCell"];
    
    accounts = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey];
    
    accountCell = [[SelectionCell alloc] initWithIdentifier:@"accountCell"];
    NSDictionary *account = [accounts objectAtIndex:0];
    accountCell.option.text = @"Account:";
    accountCell.value.text = [account objectForKey:@"name"];
    
    categoryCell = [[SelectionCell alloc] initWithIdentifier:@"categoryCell"];
    categoryCell.option.text = @"Category:";
    categoryCell.value.text = @"Taxes";
    subCategoryCell = [[SelectionCell alloc] initWithIdentifier:@"categoryCell"];
    subCategoryCell.option.text = @"Sub Category:";
    subCategoryCell.value.text = @"Local Tax";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell = transactionTypeCell;
                    break;
                case 1:
                    cell = transactionDescriptionCell;
                    break;
                case 2:
                    cell = transactionAmountCell;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell = accountCell;
                    break;
                case 1:
                    cell = categoryCell;
                    break;
                case 2:
                    cell = subCategoryCell;
                    break;
            }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return 45.0;
                case 1:
                    return 80.0;
                case 2:
                    return 80.0;
                default:
                    return 40.0;
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                    return 45.0;
                case 1:
                    return 45.0;
                case 2:
                    return 45.0;
                default:
                    return 40.0;
            }
        default:
            return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [transactionAmountCell.amountBox resignFirstResponder];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showAccountSelectionList];
                    break;
                case 1:
                    [self showCategorySelectionList];
                    break;
                case 2:
                    [self showSubCategorySelectionList];
                    break;
            }
            break;
    }
}

- (void)showAccountSelectionList {
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = accounts;
    vc.selectedKey = accountCell.value.text;
    vc.optionDelagate = accountCell.value;
    vc.title = @"Select Account";
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)showCategorySelectionList {
    NSDictionary *category1 = @{@"name": @"Personal"};
    NSDictionary *category2 = @{@"name": @"Taxes"};
    NSDictionary *category3 = @{@"name": @"Health"};
    NSArray *list = [[NSArray alloc] initWithObjects:category1,category2,category3,nil];
    
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = list;
    vc.selectedKey = categoryCell.value.text;
    vc.optionDelagate = categoryCell.value;
    vc.title = @"Select Category";
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)showSubCategorySelectionList {
    NSDictionary *category1 = @{@"name": @"Local Tax"};
    NSDictionary *category2 = @{@"name": @"Clothes"};
    NSDictionary *category3 = @{@"name": @"Restaurant"};
    NSArray *list = [[NSArray alloc] initWithObjects:category1,category2,category3,nil];
    
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = list;
    vc.selectedKey = subCategoryCell.value.text;
    vc.optionDelagate = subCategoryCell.value;
    vc.title = @"Select SubCategory";
    [[self navigationController] pushViewController:vc animated:YES];
}


@end
