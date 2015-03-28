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
    accountList = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].authToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return accountList.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Leandro";
}

@end
