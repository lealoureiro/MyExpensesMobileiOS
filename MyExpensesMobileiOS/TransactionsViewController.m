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

NSArray *accountList;
NSArray *transactionsList;
NSMutableDictionary *cellsGroupedByDays;
NSMutableArray *transactionsDays;
NSNumberFormatter *formatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setNegativeFormat:@"###0.00"];
    [formatter setPositiveFormat:@"###0.00"];
    
    self.accountChooser.dataSource = self;
    self.accountChooser.delegate = self;
    accountList = [ExpensesCoreServerAPI getUserAccounts:[ApplicationState getInstance].apiKey];
    NSString *account = [accountList objectAtIndex:0][@"id"];
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:account withApiKey:[ApplicationState getInstance].apiKey];
    [self arrangeTransactions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Selected account %ld to view transactions", row);
    NSString *account = [accountList objectAtIndex:row][@"id"];
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:account withApiKey:[ApplicationState getInstance].apiKey];
    [self arrangeTransactions];
    [self.transactionsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    NSNumber *amount = transaction[@"amount"];
    cell.amount.text = [formatter stringFromNumber:amount];
    if ([amount floatValue] > 0) {
        cell.amount.textColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
    } else if ([amount floatValue] < 0){
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
