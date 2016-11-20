//
//  AddExpenseFormTableViewController.h
//  MyExpense
//
//  Created by Leandro Loureiro on 28/04/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListSelectorViewController.h"
#import "TagsViewController.h"
#import <THDatePickerViewController.h>


@interface NewTransactionFormViewController : UITableViewController <ListSelectorDelegate, TagsSelectorDelegate, THDatePickerDelegate>

@end
