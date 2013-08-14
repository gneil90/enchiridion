//
//  NSDate+GetDayInteger.h
//  templateARC
//
//  Created by Mac Owner on 6/26/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (getDayInteger)

-(NSInteger)getDayIntegerFromDate;


@end

@interface  NSDate (getMonthInteger)
-(NSInteger)getMonthInteger;
@end

@interface NSDate (dateByDayByYearByMonth)
+(NSDate*)setDateByComponentDay:(NSInteger)day byMonth:(NSInteger)month andByYear:(NSInteger)year;
@end

@interface NSDate (getYearInteger)
-(NSInteger)getYearInteger;
@end

@interface NSDate (dateByComponents)

-(NSDate*)setupWithComponentsDay:(unsigned int)day hour:(unsigned int)hour minute:(unsigned int)minute second:(unsigned int)second;

@end
