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
#import "CategoryCell.h"

@interface NewTransactionFormViewController ()

@end

@implementation NewTransactionFormViewController

TransactionDescriptionTableViewCell *transactionDescriptionCell;
TransactionAmountTableViewCell *transactionAmountCell;
TransactionTypeCell *transactionTypeCell;
CategoryCell *categoryCell;
CategoryCell *subCategoryCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Transaction";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    transactionDescriptionCell = [[TransactionDescriptionTableViewCell alloc] initWithIdentifier:@"descriptionCell"];
    transactionAmountCell = [[TransactionAmountTableViewCell alloc] initWithIdentifier:@"amountCell"];
    transactionTypeCell = [[TransactionTypeCell alloc] initWithIdentifier:@"typeCell"];
    categoryCell = [[CategoryCell alloc] initWithIdentifier:@"categoryCell"];
    categoryCell.option.text = @"Category:";
    categoryCell.value.text = @"Taxes";
    subCategoryCell = [[CategoryCell alloc] initWithIdentifier:@"categoryCell"];
    subCategoryCell.option.text = @"Sub Category:";
    subCategoryCell.value.text = @"Local Tax";
}

- (void)viewWillAppear:(BOOL)animated {
    
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
            return 2;
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
                    cell = categoryCell;
                    break;
                case 1:
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
                default:
                    return 40.0;
            }
        default:
            return 40;
    }
}

    
@end
