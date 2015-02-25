//
//  Section.m
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "Section.h"

@implementation Section

- (instancetype) init {
    self = [super init];
    if (self) {
        _arrNavPoints = [NSArray array];
    }
    return self;
}

@end
