//
//  Supplier.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Supplier : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;

@end
