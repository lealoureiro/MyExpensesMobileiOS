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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountChooser.dataSource = self;
    self.accountChooser.delegate = self;
    accountList = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
