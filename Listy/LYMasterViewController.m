//
//  LYMasterViewController.m
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import "LYMasterViewController.h"
#import "LYNewItemViewController.h"
#import "LYItemData.h"

@interface LYMasterViewController () {
}

@property (readonly) NSArray *itemsUncooked;
@property (readonly) NSArray *itemsCooked;

@end

@implementation LYMasterViewController

@synthesize items = _items;

- (void)createNewItemWithTitle:(NSString *)title url:(NSString *)url cookedDate:(NSDate *)cookedDate cookedImage:(UIImage *)cookedImage
{
    LYItemData *item = [[LYItemData alloc] initWithTitle:title url:url cookedDate:cookedDate cookedImage:cookedImage];
    [_items insertObject:item atIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Uncooked";
    else
        return @"Cooked";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.itemsUncooked.count;
    else
        return self.itemsCooked.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellTemplate;
    if (indexPath.section == 0)
        cellTemplate = @"BasicCell";
    else
        cellTemplate = @"CookedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTemplate
                                                            forIndexPath:indexPath];

    LYItemData *item;
    // TODO: Fix N^2 lookup
    if (indexPath.section == 0)
    {
        item = self.itemsUncooked[indexPath.row];
        cell.detailTextLabel.text = item.url;
    }
    else
    {
        item = self.itemsCooked[indexPath.row];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        cell.detailTextLabel.text = [dateFormat stringFromDate:item.cookedDate];
    }
    
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing || indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"displayExistingItem" sender:self];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSArray *itemsArray = (indexPath.section == 0 ? self.itemsUncooked : self.itemsCooked);
        LYItemData *item = itemsArray[indexPath.row];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: item.url]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayNewItem"]) {
        [segue.destinationViewController setParent:self];
    } else if ([[segue identifier] isEqualToString:@"displayExistingItem"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *itemsArray = (indexPath.section == 0 ? self.itemsUncooked : self.itemsCooked);
        LYItemData *item = itemsArray[indexPath.row];

        [segue.destinationViewController setParent:self];
        [segue.destinationViewController setItem:item];
    }
}

- (NSArray *)itemsUncooked
{
    return [self getCookedItems:NO];
}

- (NSArray *)itemsCooked
{
    return [self getCookedItems:YES];
}

- (NSArray *)getCookedItems:(bool)cooked
{
    NSMutableArray *arr = [NSMutableArray array];
    for (LYItemData *item in _items)
    {
        if ((cooked && item.cookedDate) || (!cooked && !item.cookedDate))
            [arr addObject:item];
    }
    return arr;
}

@end
