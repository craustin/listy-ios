//
//  LYItemData.h
//  Listy
//
//  Created by Craig Austin on 8/16/14.
//  Copyright (c) 2014 Triply. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYItemData : NSObject

@property (strong) NSString *title;
@property (strong) NSString *url;
@property (strong) NSDate *cookedDate;
@property (strong) UIImage *cookedImage;

- (id)initWithTitle:(NSString *)title url:(NSString *)url cookedDate:(NSDate *)cookedDate cookedImage:(UIImage *)cookedImage;

@end
