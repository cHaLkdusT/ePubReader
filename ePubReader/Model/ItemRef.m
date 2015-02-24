//
//  ItemRef.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ItemRef.h"

@implementation ItemRef

- (instancetype)initWithTBXMLElement:(TBXMLElement *)element
{
    self = [super init];
    if (self) {
        self.idRef = [TBXML valueOfAttributeNamed:@"idref" forElement:element];
    }
    return self;
}

@end
