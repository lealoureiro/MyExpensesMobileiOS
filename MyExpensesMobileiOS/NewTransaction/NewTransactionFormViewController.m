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
#import "SubmitButtonCell.h"
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
SubmitButtonCell *submitCell;

NSString *selectedAcount;
NSArray *accounts;
NSMutableDictionary *accountsMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Transaction";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    transactionDescriptionCell = [[TransactionDescriptionTableViewCell alloc] initWithIdentifier:@"descriptionCell"];
    transactionAmountCell = [[TransactionAmountTableViewCell alloc] initWithIdentifier:@"amountCell"];
    transactionTypeCell = [[TransactionTypeCell alloc] initWithIdentifier:@"typeCell"];
    
    accounts = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey];
    
    accountsMap = [[NSMutableDictionary alloc] init];
    for (NSDictionary *account in accounts) {
        [accountsMap setObject:account[@"name"] forKey:account[@"id"]];
    }
    
    accountCell = [[SelectionCell alloc] initWithIdentifier:@"accountCell"];
    NSDictionary *account = [accounts objectAtIndex:0];
    accountCell.option.text = @"Account:";
    accountCell.value.text = [account objectForKey:@"name"];
    selectedAcount = [account objectForKey:@"id"];
    
    categoryCell = [[SelectionCell alloc] initWithIdentifier:@"categoryCell"];
    categoryCell.option.text = @"Category:";
    categoryCell.value.text = @"Taxes";
    
    subCategoryCell = [[SelectionCell alloc] initWithIdentifier:@"categoryCell"];
    subCategoryCell.option.text = @"Sub Category:";
    subCategoryCell.value.text = @"Local Tax";
    
    submitCell = [[SubmitButtonCell alloc] initWithIdentifier:@"submitCell"];
    [submitCell.submitButton addTarget:self action:@selector(addTransaction) forControlEvents:UIControlEventTouchUpInside];
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
            return 4;
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
                case 3:
                    cell = submitCell;
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
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                    return 45.0;
                case 1:
                    return 45.0;
                case 2:
                    return 45.0;
                case 3:
                    return 100.0;
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
    vc.selectedKey = selectedAcount;
    vc.type = @"accounts";
    vc.delegate = self;
    vc.title = @"Select Account";
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)showCategorySelectionList {
    NSDictionary *category1 = @{@"name": @"Personal", @"id": @"Personal"};
    NSDictionary *category2 = @{@"name": @"Taxes", @"id": @"Taxes"};
    NSDictionary *category3 = @{@"name": @"Health", @"id": @"Health"};
    NSArray *list = [[NSArray alloc] initWithObjects:category1,category2,category3,nil];
    
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = list;
    vc.selectedKey = categoryCell.value.text;
    vc.type = @"category";
    vc.delegate = self;
    vc.title = @"Select Category";
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)showSubCategorySelectionList {
    NSDictionary *category1 = @{@"name": @"Local Tax", @"id": @"Local Tax"};
    NSDictionary *category2 = @{@"name": @"Clothes", @"id": @"Clothes"};
    NSDictionary *category3 = @{@"name": @"Restaurant", @"id": @"Restaurant"};
    NSArray *list = [[NSArray alloc] initWithObjects:category1,category2,category3,nil];
    
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = list;
    vc.selectedKey = subCategoryCell.value.text;
    vc.type = @"sub_category";
    vc.delegate = self;
    vc.title = @"Select SubCategory";
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)setSelectedItem:(ListSelectorViewController *)selector didSelectKey:(NSString *)key {
    NSLog(@"Selected %@ from the list of %@", key, selector.type);
    
    if ([selector.type isEqualToString:@"accounts"]) {
        selectedAcount = key;
        accountCell.value.text = [accountsMap objectForKey:key];
    } else if ([selector.type isEqualToString:@"category"]){
        categoryCell.value.text = key;
    } else if ([selector.type isEqualToString:@"sub_category"]) {
        subCategoryCell.value.text = key;
    }
}

- (void)addTransaction {
    NSLog(@"Adding new trasaction for account %@", selectedAcount);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *unparsedAmount = [transactionAmountCell.amountBox.text stringByReplacingOccurrencesOfString:formatter.currencySymbol withString:@""];
    NSScanner *scanner = [NSScanner localizedScannerWithString:unparsedAmount];
    double result;
    [scanner scanDouble:&result];
    result *= 100.0;
    NSInteger amountInCents = result;
    
    if (transactionTypeCell.transactionType.selectedSegmentIndex == 0) {
        amountInCents *= -1;
    }
    
    NSError *error = nil;
    NSString *newTransactionId = [ExpensesCoreServerAPI addTransactionToAccount:selectedAcount
                                                                withDescription:transactionDescriptionCell.descriptionBox.text
                                                                     withAmount:amountInCents
                                                                   withCategory:categoryCell.value.text
                                                                withSubCategory:subCategoryCell.value.text
                                                                      andAPIKey:[ApplicationState getInstance].apiKey
                                                                       andError:&error];
    if (error == nil) {
        NSLog(@"Transaction added with ID %@", newTransactionId);
    } else {
        NSLog(@"Error ocurred when adding new transaction: %@", error.description);
    }
}

@end
