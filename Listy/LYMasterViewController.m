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
@end

@implementation LYMasterViewController

@synthesize items = _items;

-(void)setItems:(LYItemList *)items
{
    _items = items;
    items.delegate = self;
}

-(void)dataUpdated
{
    [self.tableView reloadData];
}

- (void)createNewItemWithTitle:(NSString *)title url:(NSString *)url cookedDate:(NSDate *)cookedDate cookedImage:(UIImage *)cookedImage
{
    LYItemData *item = [[LYItemData alloc] initWithTitle:title url:url cookedDate:cookedDate cookedImage:cookedImage];
    [_items insertItem:item];
}

- (void)childUpdatedItem:(LYItemData *)item
{
    [_items updateItem:item];
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
        return self.items.uncooked.count;
    else
        return self.items.cooked.count;
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
        item = self.items.uncooked[indexPath.row];
        cell.detailTextLabel.text = item.url;
    }
    else
    {
        item = self.items.cooked[indexPath.row];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        cell.detailTextLabel.text = [dateFormat stringFromDate:item.cookedDate];
    }
    
    cell.textLabel.text = item.title;
    cell.textLabel.accessibilityLabel = item.key;
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
        NSArray *itemsArray = (indexPath.section == 0 ? self.items.uncooked : self.items.cooked);
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
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [_items removeKey:cell.textLabel.accessibilityLabel];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayNewItem"]) {
        [segue.destinationViewController setParent:self];
    } else if ([[segue identifier] isEqualToString:@"displayExistingItem"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *itemsArray = (indexPath.section == 0 ? self.items.uncooked : self.items.cooked);
        LYItemData *item = itemsArray[indexPath.row];

        [segue.destinationViewController setParent:self];
        [segue.destinationViewController setItem:item];
    }
}

@end
