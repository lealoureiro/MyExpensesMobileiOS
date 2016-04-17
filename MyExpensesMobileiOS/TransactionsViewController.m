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
NSArray *transactionsList;
NSMutableDictionary *cellsGroupedByDays;
NSMutableArray *transactionsDays;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    static NSString *simpleTableIdentifier = @"transactionTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewStylePlain;
    }
    
    id key = [transactionsDays objectAtIndex:indexPath.section];
    NSArray *transactionsForSection = [cellsGroupedByDays objectForKey:key];
    NSDictionary *transaction = [transactionsForSection objectAtIndex:indexPath.row];
    
    cell.textLabel.text = transaction[@"description"];
    NSNumber *timestamp = transaction[@"timestamp"];
    long timestampSeconds = [timestamp longValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampSeconds];
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
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
