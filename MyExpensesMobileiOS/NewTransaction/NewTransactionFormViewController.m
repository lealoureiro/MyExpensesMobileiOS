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
NSMutableArray *accounts;
NSMutableDictionary *accountsMap;
NSMutableArray *categoriesList;
NSMutableDictionary *categoriesMap;

BOOL updateCategories = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Transaction";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    transactionDescriptionCell = [[TransactionDescriptionTableViewCell alloc] initWithIdentifier:@"descriptionCell"];
    transactionAmountCell = [[TransactionAmountTableViewCell alloc] initWithIdentifier:@"amountCell"];
    transactionTypeCell = [[TransactionTypeCell alloc] initWithIdentifier:@"typeCell"];
    
    if ([ApplicationState getInstance].logged) {
        
        accounts = [[NSMutableArray alloc] initWithArray:[ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey]];
        
        accountsMap = [[NSMutableDictionary alloc] init];
        for (NSDictionary *account in accounts) {
            [accountsMap setObject:account[@"name"] forKey:account[@"id"]];
        }
        
        [self refreshCategories];
    }
    
    accountCell = [[SelectionCell alloc] initWithIdentifier:@"accountCell"];
   
    accountCell.option.text = @"Account:";
    if (accounts.count > 0) {
        NSDictionary *account = [accounts objectAtIndex:0];
        accountCell.value.text = [account objectForKey:@"name"];
        selectedAcount = [account objectForKey:@"id"];
    }
    
    categoryCell = [[SelectionCell alloc] initWithIdentifier:@"categoryCell"];
    categoryCell.option.text = @"Category:";
    
    subCategoryCell = [[SelectionCell alloc] initWithIdentifier:@"categoryCell"];
    subCategoryCell.option.text = @"Sub Category:";
    
    if (categoriesList.count > 0) {
        NSDictionary *category = [categoriesList objectAtIndex:0];
        categoryCell.value.text = [category objectForKey:@"name"];
        
        NSArray *subCategories = [category objectForKey:@"subCategories"];
        if (subCategories.count > 0) {
            subCategoryCell.value.text = [subCategories objectAtIndex:0];
        } else {
            subCategoryCell.value.text = @"";
        }
    }
    
    submitCell = [[SubmitButtonCell alloc] initWithIdentifier:@"submitCell"];
    submitCell.resultLabel.alpha = 0.0;
    [submitCell.submitButton addTarget:self action:@selector(addTransaction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    if (updateCategories) {
        [self refreshCategories];
        updateCategories = NO;
    }
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
    
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = categoriesList;
    vc.selectedKey = categoryCell.value.text;
    vc.type = @"category";
    vc.update = &updateCategories;
    vc.delegate = self;
    vc.title = @"Select Category";
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)showSubCategorySelectionList {
    ListSelectorViewController *vc = [[ListSelectorViewController alloc] init];
    vc.list = [categoriesMap objectForKey:categoryCell.value.text];
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
        NSArray *subCategoriesList = [categoriesMap objectForKey:key];
        if (subCategoriesList.count > 0) {
            subCategoryCell.value.text = [[subCategoriesList objectAtIndex:0] objectForKey:@"name"];
        } else {
             subCategoryCell.value.text = @"";
        }
    } else if ([selector.type isEqualToString:@"sub_category"]) {
        subCategoryCell.value.text = key;
    }
    
}

- (void)addTransaction {
    NSLog(@"Adding new trasaction for account %@", selectedAcount);
    
    submitCell.submitButton.enabled = NO;
    
    NSInteger amountInCents = transactionAmountCell.amountInCents;
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
        submitCell.resultLabel.textColor = [UIColor greenColor];
        submitCell.resultLabel.text = @"Transaction added successfully!";
        [self animateResultLabel];
    } else {
        NSLog(@"Error ocurred when adding new transaction: %@", error.description);
        submitCell.resultLabel.textColor = [UIColor redColor];
        submitCell.resultLabel.text = @"An error occurred!";
        [self animateResultLabel];
    }
    
    submitCell.submitButton.enabled = YES;
}


- (void)animateResultLabel {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         submitCell.resultLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.25
                                               delay:2
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              submitCell.resultLabel.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}

- (void)refreshCategories {
    NSLog(@"Fetching categories and sub categories");
    NSArray *categories = [ExpensesCoreServerAPI getUserCategories:[ApplicationState getInstance].apiKey];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    
    categoriesList = [[NSMutableArray alloc] initWithCapacity:categories.count];
    categoriesMap = [[NSMutableDictionary alloc] init];
    for (NSDictionary *category in categories) {
        NSString *categoryName = [category objectForKey:@"name"];
        NSDictionary *category1 = @{@"name": categoryName, @"id": categoryName};
        [categoriesList addObject:category1];
        
        NSArray *subCategories = [category objectForKey:@"subCategories"];
        NSMutableArray *subCategoriesList = [[NSMutableArray alloc] initWithCapacity:subCategories.count];
        for (NSString *subCategory in subCategories) {
            NSDictionary *subCategory1 = @{@"name": subCategory, @"id": subCategory};
            [subCategoriesList addObject:subCategory1];
        }
        
        [subCategoriesList sortUsingDescriptors:sortDescriptors];
        
        [categoriesMap setObject:subCategoriesList forKey:categoryName];
    }
    
    [categoriesList sortUsingDescriptors:sortDescriptors];

}

@end
