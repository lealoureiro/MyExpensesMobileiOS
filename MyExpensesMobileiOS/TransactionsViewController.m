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
#import "TransactionTableCell.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController

@synthesize account;



NSDictionary *accountInformation;
NSArray *transactionsList;
NSMutableDictionary *cellsGroupedByDays;
NSMutableArray *transactionsDays;
NSNumberFormatter *formatter;

UILabel *amountLabel;
UILabel *accountTypeLabel;
UILabel *accountNameLabel;
UITableView *transactionsTable;


- (void)loadView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    accountNameLabel = [[UILabel alloc] init];
    accountNameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    accountNameLabel.textAlignment =  NSTextAlignmentLeft;
    accountNameLabel.layer.borderColor = [UIColor blackColor].CGColor;
    accountNameLabel.text = account[@"name"];
    accountNameLabel.hidden = NO;
    [accountNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:accountNameLabel];
    
    amountLabel = [[UILabel alloc] init];
    amountLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    amountLabel.textAlignment =  NSTextAlignmentLeft;
    amountLabel.layer.borderColor = [UIColor blackColor].CGColor;
    amountLabel.hidden = NO;
    [amountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:amountLabel];
    
    accountTypeLabel = [[UILabel alloc] init];
    accountTypeLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    accountTypeLabel.textAlignment =  NSTextAlignmentLeft;
    accountTypeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    accountTypeLabel.hidden = NO;
    [accountTypeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:accountTypeLabel];
    
    transactionsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    transactionsTable.delegate = self;
    transactionsTable.dataSource = self;
    transactionsTable.rowHeight = UITableViewAutomaticDimension;
    transactionsTable.estimatedRowHeight = 50;
    [transactionsTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:transactionsTable];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(amountLabel, accountNameLabel, accountTypeLabel, transactionsTable);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[accountNameLabel]-15-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[accountTypeLabel]-15-[amountLabel]-15-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[transactionsTable]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[accountNameLabel]-15-[amountLabel]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[accountNameLabel]-15-[accountTypeLabel]-15-[transactionsTable]|" options:0 metrics:nil views:views]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"Loading account information screen for account %@", self.account[@"id"]);
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    UIEdgeInsets adjustedInsets = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    transactionsTable.contentInset = adjustedInsets;
    transactionsTable.scrollIndicatorInsets = adjustedInsets;
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.title = @"Account Information";
    
    accountInformation = [ExpensesCoreServerAPI getAccountInformation:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
    
    NSNumber *startBalance = accountInformation[@"startBalance"];
    NSNumber *balance = accountInformation[@"balance"];
    double total = ([startBalance doubleValue] + [balance doubleValue]) / 100.0;
    amountLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];
    
    accountTypeLabel.text = account[@"type"];
    
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
    [self arrangeTransactions];
    transactionsTable.allowsMultipleSelectionDuringEditing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id key = [transactionsDays objectAtIndex:section];
    NSArray *transactionsForSection = [cellsGroupedByDays objectForKey:key];
    return transactionsForSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"transactionCell";
    
    TransactionTableCell *cell = (TransactionTableCell*) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[TransactionTableCell alloc] init];
        cell.selectionStyle = UITableViewStylePlain;
    }
    
    id key = [transactionsDays objectAtIndex:indexPath.section];
    NSArray *transactionsForSection = [cellsGroupedByDays objectForKey:key];
    NSDictionary *transaction = [transactionsForSection objectAtIndex:indexPath.row];
    
    NSMutableString *category = [[NSMutableString alloc] init];
    [category appendString:transaction[@"category"]];
    if (![@"" isEqualToString:transaction[@"subCategory"]]) {
        [category appendString:@":"];
        [category appendString:transaction[@"subCategory"]];
    }
    if ([@"" isEqualToString:transaction[@"description"]]) {
        cell.description.text = @"(No Description)";
    } else {
        cell.description.text = transaction[@"description"];
    }
    cell.category.text = category;
    NSNumber *transactionAmount = transaction[@"amount"];
    double amount = [transactionAmount doubleValue] / 100.0;
    cell.amount.text = [formatter stringFromNumber:[NSNumber numberWithDouble:amount]];
    if ([transactionAmount floatValue] > 0) {
        cell.amount.textColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
    } else if ([transactionAmount floatValue] < 0){
        cell.amount.textColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];

    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return transactionsDays.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [transactionsDays objectAtIndex:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id key = [transactionsDays objectAtIndex:indexPath.section];
        NSMutableArray *transactionsForSection = [cellsGroupedByDays objectForKey:key];
        NSDictionary *transaction = [transactionsForSection objectAtIndex:indexPath.row];
        NSString *transactionId = [transaction objectForKey:@"id"];
        NSString *accountId = self.account[@"id"];
        NSNumber *timestamp = [transaction objectForKey:@"timestamp"];
        NSLog(@"Deleting transaction %@ in account %@", transactionId, accountId);
        
        NSError *error;
        
        [ExpensesCoreServerAPI deleteTransaction:transactionId inAccount:accountId withTimestamp:timestamp andAPIKey:[ApplicationState getInstance].apiKey andError:&error];
        
        if (error == nil) {
            [transactionsForSection removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            NSLog(@"Transaction %@ deleted", transactionId);
            
            accountInformation = [ExpensesCoreServerAPI getAccountInformation:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
            
            NSNumber *startBalance = accountInformation[@"startBalance"];
            NSNumber *balance = accountInformation[@"balance"];
            double total = ([startBalance doubleValue] + [balance doubleValue]) / 100.0;
            amountLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];
            
        } else {
            NSLog(@"Failed to delete transaction %@", transactionId);
        }
    }
}

- (void)arrangeTransactions {
    cellsGroupedByDays = [NSMutableDictionary dictionaryWithCapacity:0];
    transactionsDays = [NSMutableArray arrayWithCapacity:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.locale = [NSLocale currentLocale];
    formater.timeZone = calendar.timeZone;
    [formater setDateFormat:@"dd MMMM YYYY"];
    
    NSString *previousGroup = @"";
    NSMutableArray *transctionsForSection = nil;
    
    for (NSDictionary *transaction in transactionsList) {
        NSNumber *timestamp = transaction[@"timestamp"];
        long timestampSeconds = [timestamp longValue] / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampSeconds];
        NSString *currentDay = [formater stringFromDate:date];
        if (![previousGroup isEqualToString:currentDay]) {
            [transactionsDays addObject:currentDay];
            transctionsForSection = [NSMutableArray arrayWithCapacity:0];
            [cellsGroupedByDays setObject:transctionsForSection forKey:currentDay];
            previousGroup = currentDay;
        }
        [transctionsForSection addObject:transaction];
    }
}


@end
