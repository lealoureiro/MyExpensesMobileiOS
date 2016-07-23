//
//  ListSelectorViewController.m
//  MyExpense
//
//  Created by Leandro Loureiro on 10/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "ListSelectorViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@interface ListSelectorViewController ()

@end

@implementation ListSelectorViewController

@synthesize list;
@synthesize selectedKey;
@synthesize type;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.type isEqualToString:@"accounts"]){
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addNewItem)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
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
    if ([selectedKey isEqualToString: [option objectForKey:@"id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *option = [list objectAtIndex:indexPath.row];
    [self.delegate setSelectedItem:self didSelectKey:[option objectForKey:@"id"]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addNewItem {
    UIAlertController *alert = [UIAlertController
                                 alertControllerWithTitle:@"Add new category"
                                 message:@"Please enter the new category name:"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *addButton = [UIAlertAction
                                actionWithTitle:@"Add"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    NSArray *textfields = alert.textFields;
                                    UITextField *name = textfields[0];
                                    if ([self.type isEqualToString:@"category"]) {
                                        [self addNewCategory:name.text];
                                    }
                                }];
    
    UIAlertAction *cancelButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                               }];
    
    [alert addAction:addButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addNewCategory:(NSString *)newCategory {
    NSError *error = nil;
    [ExpensesCoreServerAPI addNewCategory:newCategory andAPIKey:[ApplicationState getInstance].apiKey andError:&error];
    if (error == nil) {
        NSLog(@"Category %@ added successfully!", newCategory);
        NSDictionary *category = @{@"name": newCategory, @"id": newCategory};
        self.list = [self.list arrayByAddingObject:category];
        [self.tableView reloadData];
    }
}

@end
