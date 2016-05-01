//
//  TransactionTableCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 17/04/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *description;
@property (strong, nonatomic) UILabel *amount;
@property (strong, nonatomic) UILabel *category;


@end
