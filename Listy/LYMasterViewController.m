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
#import "MBProgressHUD.h"

@interface LYMasterViewController () {
    NSArray *_uncookedSearchResults;
    NSArray *_cookedSearchResults;
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
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];

    // update proper TableView (to avoid bug with section headers showing through)
    if (self.searchDisplayController.isActive)
        [self.searchDisplayController.searchResultsTableView reloadData];
    else
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
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Hide the search bar on startup.
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayNewItem"]) {
        [segue.destinationViewController setParent:self];
    } else if ([[segue identifier] isEqualToString:@"displayExistingItem"]) {
        UITableView *tableView = (UITableView *)sender;
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSArray *itemsArray = [self getItemsArrayForTableView:tableView section:indexPath.section];
        LYItemData *item = itemsArray[indexPath.row];
        
        [segue.destinationViewController setParent:self];
        [segue.destinationViewController setItem:item];
    }
}

- (NSArray *)getItemsArrayForTableView:(UITableView *)tableView section:(int)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (section == 0)
            return _uncookedSearchResults;
        else
            return _cookedSearchResults;
    } else {
        if (section == 0)
            return self.items.uncooked;
        else
            return self.items.cooked;
    }
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
    return [self getItemsArrayForTableView:tableView section:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellTemplate;
    if (indexPath.section == 0)
        cellTemplate = @"BasicCell";
    else
        cellTemplate = @"CookedCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellTemplate
                                                                 forIndexPath:indexPath];

    LYItemData *item = [self getItemsArrayForTableView:tableView section:indexPath.section][indexPath.row];
    if (indexPath.section == 0)
    {
        cell.detailTextLabel.text = item.url;
    }
    else
    {
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
        [self performSegueWithIdentifier:@"displayExistingItem" sender:tableView];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        NSArray *itemsArray = [self getItemsArrayForTableView:tableView section:indexPath.section];
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
        
        // update tableView so that we get proper animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    // we don't load normal tableView during search - so update it afterward
    [self.tableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    _uncookedSearchResults = [self.items.uncooked filteredArrayUsingPredicate:resultPredicate];
    _cookedSearchResults = [self.items.cooked filteredArrayUsingPredicate:resultPredicate];
}

@end
