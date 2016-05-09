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
#import "TransactionCategoryTableViewCell.h"
#import "TransactionTypeCell.h"

@interface NewTransactionFormViewController ()

@end

@implementation NewTransactionFormViewController

TransactionDescriptionTableViewCell *transactionDescriptionCell;
TransactionAmountTableViewCell *transactionAmountCell;
TransactionCategoryTableViewCell *transactionCategoryCell;
TransactionTypeCell *transactionTypeCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Transaction";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    transactionDescriptionCell = [[TransactionDescriptionTableViewCell alloc] initWithIdentifier:@"descriptionCell"];
    transactionAmountCell = [[TransactionAmountTableViewCell alloc] initWithIdentifier:@"amountCell"];
    transactionCategoryCell = [[TransactionCategoryTableViewCell alloc] initWithIdentifier:@"categoryCell"];
    transactionTypeCell = [[TransactionTypeCell alloc] initWithIdentifier:@"typeCell"];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
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
        case 3:
            cell = transactionCategoryCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 45.0;
        case 1:
            return 80.0;
        case 2:
            return 80.0;
        case 3:
            return 100.0;
        default:
            return 40.0;
    }
}






@end
