//
//  Subobjective.h
//  templateARC
//
//  Created by Mac Owner on 7/2/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fugitive;

@interface Subobjective : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * isReached;
@property (nonatomic, retain) Fugitive *parentObj;

@end
