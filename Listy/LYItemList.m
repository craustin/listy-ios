//
//  LYItemList.m
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <Firebase/Firebase.h>

#import "LYItemList.h"

@interface LYItemList () {
    NSMutableDictionary *_items;
    Firebase *_ref;
}
@end

@implementation LYItemList

@synthesize delegate = _delegate;

+ (LYItemList *)getSample
{
    NSString *dateString = @"12-Jul-14";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yy";
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    LYItemData *item1 = [[LYItemData alloc] initWithTitle:@"Tasty Steak" url:@"http://meaty.com" cookedDate:nil cookedImage:nil];
    LYItemData *item2 = [[LYItemData alloc] initWithTitle:@"Moroccan Chicken" url:@"http://spicy.ma" cookedDate:nil cookedImage:nil];
    LYItemData *item3 = [[LYItemData alloc] initWithTitle:@"Chinese Dish" url:@"http://foods.cn" cookedDate:nil cookedImage:nil];
    LYItemData *item4 = [[LYItemData alloc] initWithTitle:@"Pizza" url:@"http://xiaoyi.co.uk" cookedDate:date cookedImage:nil];
    
    LYItemList *list = [[LYItemList alloc] init];
    [list insertItem:item1];
    [list insertItem:item2];
    [list insertItem:item3];
    [list insertItem:item4];
    return list;
}

+ (LYItemList *)loadFromFireBase
{
    LYItemList *list = [[LYItemList alloc] init];
    Firebase *itemsRef = [list->_ref childByAppendingPath: @"items"];
    
    // Catch add/update events.
    [itemsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *values = snapshot.value;
        for (NSString *key in values.allKeys)
        {
            LYItemData *item = [[LYItemData alloc] initWithDict:[values valueForKey:key] key:key];
            [list insertItemToDict:item];
        }
        [list->_delegate dataUpdated];
    }];
    
    // Catch remove events.
    [itemsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSString *key = snapshot.name;
        [list->_items removeObjectForKey:key];
        [list->_delegate dataUpdated];
    }];
    
    // TODO: Lock around _items
    return list;
}

- (id)init
{
    if ((self = [super init])) {
        _ref = [[Firebase alloc] initWithUrl:@"https://listy-meals.firebaseio.com/"];
    }
    return self;
}

- (void)insertItemToDict:(LYItemData *)item
{
    if (!_items)
        _items = [NSMutableDictionary dictionary];
    [_items setValue:item forKey:item.key];
}

- (void)insertItem:(LYItemData *)item
{
    Firebase *itemsRef = [_ref childByAppendingPath: @"items"];
    Firebase *newItemRef = [itemsRef childByAutoId];
    [newItemRef setValue:[item asDict]];
    item.key = newItemRef.name;
    
    [self insertItemToDict:item];
}

- (void)updateItem:(LYItemData *)item
{
    Firebase *itemsRef = [_ref childByAppendingPath: @"items"];
    Firebase *itemRef = [itemsRef childByAppendingPath:item.key];
    [itemRef setValue:[item asDict]];
    
    [self insertItemToDict:item];
}

- (void)removeKey:(NSString *)key
{
    Firebase *itemsRef = [_ref childByAppendingPath: @"items"];
    Firebase *itemRef = [itemsRef childByAppendingPath:key];
    [itemRef setValue:nil];
    
    [_items removeObjectForKey:key];
}

- (NSArray *)uncooked
{
    return [self getCookedItems:NO];
}

- (NSArray *)cooked
{
    return [self getCookedItems:YES];
}

- (NSArray *)getCookedItems:(bool)cooked
{
    NSMutableArray *arr = [NSMutableArray array];
    for (LYItemData *item in _items.allValues)
    {
        if ((cooked && item.cookedDate) || (!cooked && !item.cookedDate))
            [arr addObject:item];
    }
    return arr;
}

@end
