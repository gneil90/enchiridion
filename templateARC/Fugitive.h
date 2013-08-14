//
//  Fugitive.h
//  templateARC
//
//  Created by Mac Owner on 5/23/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subobjective;

@interface Fugitive : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * bounty;
@property (nonatomic, retain) NSNumber * isShown;
@property (nonatomic, retain) NSNumber * isEnchiridion;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * fugitiveID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * numberOfSubobj;
@property (nonatomic, retain) NSSet *subObjective;
@end

@interface Fugitive (CoreDataGeneratedAccessors)

- (void)addSubObjectiveObject:(Subobjective *)value;
- (void)removeSubObjectiveObject:(Subobjective *)value;
- (void)addSubObjective:(NSSet *)values;
- (void)removeSubObjective:(NSSet *)values;

@end
