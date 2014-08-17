//
//  LYItemList.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYItemData.h"

@protocol LYDataUpdatedDelegate <NSObject>
@required
- (void)dataUpdated;
@end

@interface LYItemList : NSObject

- (void)insertItem:(LYItemData *)item;
- (void)updateItem:(LYItemData *)item;
- (void)removeKey:(NSString *)key;

@property (readonly) NSArray *uncooked;
@property (readonly) NSArray *cooked;
@property (weak) id<LYDataUpdatedDelegate> delegate;

+ (LYItemList *)getSample;
+ (LYItemList *)loadFromFireBase;

@end
