//
//  FirstViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "NewTransactionViewController.h"
#import "ExpensesCoreServerAPI.h"

@interface NewTransactionViewController ()

@end

@implementation NewTransactionViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *barItem = [self tabBarItem];
    barItem.image = [UIImage imageNamed:@"new_transaction"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






@end
