//
//  SecondViewController.h
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *accountChooser;
@property (weak, nonatomic) IBOutlet UITableView *transactionsTable;


@end

