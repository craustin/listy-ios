//
//  LYItemList.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYItemData.h"

@interface LYItemList : NSObject

- (void)insert:(LYItemData *)item;
- (void)removeAt:(NSInteger)pos;

// TODO: lookup by hash (dictionary)
// TODO: store hash on TableViewCell
// TODO: determine order (created date?)

@property (readonly) NSArray *uncooked;
@property (readonly) NSArray *cooked;

+ (LYItemList *)getSample;

@end
