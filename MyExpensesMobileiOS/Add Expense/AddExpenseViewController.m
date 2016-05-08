//
//  FirstViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@interface AddExpenseViewController ()

@end

@implementation AddExpenseViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *barItem = [self tabBarItem];
    barItem.image = [UIImage imageNamed:@"new_transaction"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






@end
