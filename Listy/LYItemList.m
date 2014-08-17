//
//  LYItemList.m
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import "LYItemList.h"

@interface LYItemList () {
    NSMutableArray *_items;
}
@end

@implementation LYItemList

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
    NSMutableArray *items = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, nil];
    
    LYItemList *list = [[LYItemList alloc] init];
    list->_items = items;
    return list;
}

- (void)insert:(LYItemData *)item
{
    [_items insertObject:item atIndex:0];
}

- (void)removeAt:(NSInteger)pos
{
    [_items removeObjectAtIndex:pos];
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
    for (LYItemData *item in _items)
    {
        if ((cooked && item.cookedDate) || (!cooked && !item.cookedDate))
            [arr addObject:item];
    }
    return arr;
}

@end
