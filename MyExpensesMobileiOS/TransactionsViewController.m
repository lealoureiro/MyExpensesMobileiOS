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

- (void)loadView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    UILabel *accountName = [[UILabel alloc] init];
    accountName.font = [UIFont boldSystemFontOfSize:20.0f];
    accountName.textAlignment =  NSTextAlignmentLeft;
    accountName.layer.borderColor = [UIColor blackColor].CGColor;
    accountName.text = account[@"name"];
    accountName.hidden = NO;
    [accountName setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:accountName];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accountName
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeftMargin
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accountName
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTopMargin
                                                         multiplier:0.1
                                                           constant:100.0]];
    
    
    amountLabel = [[UILabel alloc] init];
    amountLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    amountLabel.textAlignment =  NSTextAlignmentLeft;
    amountLabel.layer.borderColor = [UIColor blackColor].CGColor;
    amountLabel.hidden = NO;
    [amountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:amountLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:amountLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRightMargin
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:amountLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTopMargin
                                                         multiplier:0.1
                                                           constant:100.0]];
    
    
    accountTypeLabel = [[UILabel alloc] init];
    accountTypeLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    accountTypeLabel.textAlignment =  NSTextAlignmentLeft;
    accountTypeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    accountTypeLabel.hidden = NO;
    [accountTypeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:accountTypeLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accountTypeLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeftMargin
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accountTypeLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:accountName
                                                          attribute:NSLayoutAttributeTopMargin
                                                         multiplier:1
                                                           constant:40.0]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"Loading account information screen for account %@", self.account[@"id"]);
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setNegativeFormat:@"###0.00 €"];
    [formatter setPositiveFormat:@"###0.00 €"];
    
    self.title = @"Account Information";
    
    
    accountInformation = [ExpensesCoreServerAPI getAccountInformation:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
    
    NSNumber *startBalance = accountInformation[@"startBalance"];
    NSNumber *balance = accountInformation[@"balance"];
    double total = [startBalance doubleValue] + [balance doubleValue];
    amountLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];
    
    accountTypeLabel.text = account[@"type"];
    
    /*
    transactionsList = [ExpensesCoreServerAPI getAccountTransactions:self.account[@"id"] withApiKey:[ApplicationState getInstance].apiKey];
    [self arrangeTransactions];
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id key = [transactionsDays objectAtIndex:section];
    //NSArray *transactionsForSection = [cellsGroupedByDays objectForKey:key];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"transactionCell";
    
    TransactionTableCell *cell = (TransactionTableCell*) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[TransactionTableCell alloc] init];
        cell.selectionStyle = UITableViewStylePlain;
    }
    
    /*
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

    }*/
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"test";
}

- (void)arrangeTransactions{
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
