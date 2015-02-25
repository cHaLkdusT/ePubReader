//
//  SectionItem.m
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "SectionItem.h"

@implementation SectionItem

@synthesize base, path;
@synthesize numberOfSubitems;
@synthesize parentSelectingItem;
@synthesize ancestorSelectingItems;
@synthesize submersionLevel;

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToSelectingItem:other];
}

- (BOOL)isEqualToSelectingItem:(SectionItem *)selectingItem {
    if (self == selectingItem) {
        return YES;
    }
    
    if ([base isEqualToString:selectingItem.base] &&
        [path isEqualToString:selectingItem.path] &&
        numberOfSubitems == selectingItem.numberOfSubitems) {
        return YES;
    }
    
    return NO;
}
@end
