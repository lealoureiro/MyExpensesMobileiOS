//
//  AddExpenseFormTableViewController.m
//  MyExpense
//
//  Created by Leandro Loureiro on 28/04/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "AddExpenseFormTableViewController.h"
#import "TransactionDescriptionTableViewCell.h"
#import "TransactionAmountTableViewCell.h"

@interface AddExpenseFormTableViewController ()

@end

@implementation AddExpenseFormTableViewController

TransactionDescriptionTableViewCell *transactionDescriptionCell;
TransactionAmountTableViewCell *transactionAmountCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Transaction";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    transactionDescriptionCell = [[TransactionDescriptionTableViewCell alloc] initWithIdentifier:@"descriptionCell"];
    transactionAmountCell = [[TransactionAmountTableViewCell alloc] initWithIdentifier:@"amountCell"];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = transactionDescriptionCell;
            break;
        case 1:
            cell = transactionAmountCell;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 80.0;
        case 1:
            return 80.0;
        default:
            return 40.0;
    }
}






@end
