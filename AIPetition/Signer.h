//
//  Signer.h
//  AIPetition
//
//  Created by Robyn Poore on 12-06-21.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Signer : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * signatureID;
@property (nonatomic, retain) NSDate * timeStamp;

@end
