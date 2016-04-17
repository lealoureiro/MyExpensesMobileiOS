//
//  TransactionTableCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 17/04/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic, weak) IBOutlet UILabel *category;
@property (nonatomic, weak) IBOutlet UILabel *amount;


@end
