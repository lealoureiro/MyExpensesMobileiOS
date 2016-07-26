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
@synthesize update;
@synthesize selectedKeyAux;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.type isEqualToString:@"accounts"]){
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addNewItem)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type isEqualToString:@"category"]) {
        return YES;
    }
    
    if ([self.type isEqualToString:@"sub_category"]) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *option = [list objectAtIndex:indexPath.row];
        NSString *value = [option objectForKey:@"id"];
        NSLog(@"Deleting item %@", value);
        
        NSError *error;
        if ([self.type isEqualToString:@"category"]) {
            [ExpensesCoreServerAPI deleteCategory:value andAPIKey:[ApplicationState getInstance].apiKey andError:&error];

        } else if ([self.type isEqualToString:@"sub_category"]) {
            [ExpensesCoreServerAPI deleteSubCategory:value inCategory:self.selectedKeyAux andAPIKey:[ApplicationState getInstance].apiKey andError:&error];
        }
        
        if (error == nil) {
            [list removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            NSLog(@"Item %@ deleted", value);
        } else {
            NSLog(@"Failed to delete item %@", value);
        }
    }
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

- (void)addNewItem {
    
    NSString *description1;
    NSString *description2;
    if ([self.type isEqualToString:@"category"]) {
        description1 = @"Add new category";
        description2 = @"Please enter the new category name:";
    } else if ([self.type isEqualToString:@"sub_category"]){
        description1 = [@"Add new sub category for category " stringByAppendingString:self.selectedKeyAux];
        description2 = @"Please enter new sub category name:";
    }
    
    UIAlertController *alert = [UIAlertController
                                 alertControllerWithTitle:description1
                                 message:description2
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
                                    } else if ([self.type isEqualToString:@"sub_category"]) {
                                        [self addNewSubCategory:name.text];
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
        [self.list addObject:category];
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
        [self.list sortUsingDescriptors:sortDescriptors];
        [self.tableView reloadData];
        *update = YES;
    }
}


- (void)addNewSubCategory:(NSString *)newSubCategory {
    NSError *error = nil;
    [ExpensesCoreServerAPI addNewSubCategory:newSubCategory forCategory:self.selectedKeyAux andAPIKey:[ApplicationState getInstance].apiKey andError:&error];
    if (error == nil) {
        NSLog(@"Sub category %@ added successfully to category %@!", newSubCategory, self.selectedKeyAux);
        NSDictionary *subCategory = @{@"name": newSubCategory, @"id": newSubCategory};
        [self.list addObject:subCategory];
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
        [self.list sortUsingDescriptors:sortDescriptors];
        [self.tableView reloadData];
        *update = YES;
    }
    
}


@end
