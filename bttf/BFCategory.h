//
//  BFCategory.h
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface BFCategory : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* name;
@property (nonatomic) NSNumber* level;
@property (nonatomic) BFCategory* parent;



@end
