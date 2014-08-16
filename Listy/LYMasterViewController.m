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
    // private fields here
}
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"
                                                            forIndexPath:indexPath];

    LYItemData *item = _items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.url;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing)
    {
        [self performSegueWithIdentifier:@"displayExistingItem" sender:self];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        LYItemData *item = _items[indexPath.row];
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
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        LYItemData *item = [self.items objectAtIndex:path.row];

        [segue.destinationViewController setParent:self];
        [segue.destinationViewController setItem:item];
    }
}

@end
