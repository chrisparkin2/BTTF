//
//  BFCategory.h
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CategoryMain : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;

@end
