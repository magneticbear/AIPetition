//
//  User.h
//  AIPetition
//
//  Created by Robyn Poore on 12-06-21.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * pinCode;

@end
