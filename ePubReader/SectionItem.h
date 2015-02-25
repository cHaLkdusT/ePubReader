//
//  SectionItem.h
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionItem : NSObject

#pragma mark - Helper variables
@property (nonatomic, strong) NSMutableArray *ancestorSelectingItems;
@property (nonatomic, strong) SectionItem *parentSelectingItem;
@property (nonatomic, strong) NSString *base, *path;
@property (nonatomic) NSInteger numberOfSubitems;
@property (nonatomic) NSInteger submersionLevel;

#pragma mark - Helper methods
- (BOOL)isEqualToSelectingItem:(SectionItem *)selectingItem;
@end
