//
//  ListSelectorViewController.h
//  MyExpense
//
//  Created by Leandro Loureiro on 10/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListSelectorViewController : UITableViewController

@property NSArray *list;
@property NSString *selectedKey;
@property (weak) UILabel *optionDelagate;


@end
