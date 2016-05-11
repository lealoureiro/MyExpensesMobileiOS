//
//  ListSelectorViewController.m
//  MyExpense
//
//  Created by Leandro Loureiro on 10/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "ListSelectorViewController.h"

@interface ListSelectorViewController ()

@end

@implementation ListSelectorViewController

@synthesize list;
@synthesize selectedKey;
@synthesize optionDelagate;

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optionCell"];
    }
    
    NSDictionary *option = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = [option objectForKey:@"name"];
    if ([selectedKey isEqualToString: [option objectForKey:@"name"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.optionDelagate.text = [[list objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
