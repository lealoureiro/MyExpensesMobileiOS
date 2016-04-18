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

@synthesize accountName;
@synthesize account;
@synthesize amount;
@synthesize accountType;

NSDictionary *accountInformation;
NSArray *transactionsList;
NSMutableDictionary *cellsGroupedByDays;
NSMutableArray *transactionsDays;
NSNumberFormatter *formatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setNegativeFormat:@"###0.00 €"];
    [formatter setPositiveFormat:@"###0.00 €"];
    
    [self setTitle:@"Account Information"];
    self.accountName.text = self.account[@"name"];
    self.accountType.text = self.account[@"type"];
    
    accountInformation = [ExpensesCoreServerAPI getAccountInformation:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
    
    NSNumber *startBalance = accountInformation[@"startBalance"];
    NSNumber *balance = accountInformation[@"balance"];
    double total = [startBalance doubleValue] + [balance doubleValue];
    self.amount.text =[formatter stringFromNumber:[NSNumber numberWithDouble:total]];
    
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
    [self arrangeTransactions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [transactionsDays objectAtIndex:section];
    NSArray *transactionsForSection = [cellsGroupedByDays objectForKey:key];
    return transactionsForSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [category appendString:@":"];
    [category appendString:transaction[@"subCategory"]];
    cell.description.text = transaction[@"description"];
    cell.category.text = category;
    NSNumber *transactionAmount = transaction[@"amount"];
    cell.amount.text = [formatter stringFromNumber:transactionAmount];
    if ([transactionAmount floatValue] > 0) {
        cell.amount.textColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
    } else if ([transactionAmount floatValue] < 0){
        cell.amount.textColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];

    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return transactionsDays.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [transactionsDays objectAtIndex:section];
}

- (void)arrangeTransactions{
    cellsGroupedByDays = [NSMutableDictionary dictionaryWithCapacity:0];
    transactionsDays = [NSMutableArray arrayWithCapacity:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.locale = [NSLocale currentLocale];
    formater.timeZone = calendar.timeZone;
    [formater setDateFormat:@"dd MMMM"];
    
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
