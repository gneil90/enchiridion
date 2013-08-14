//
//  NSDate+GetDayInteger.m
//  templateARC
//
//  Created by Mac Owner on 6/26/13.
//
//

#import "NSDate+GetDayInteger.h"

@implementation NSDate(getDayInteger)
-(NSInteger)getDayIntegerFromDate
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [calendar components:NSDayCalendarUnit
                                               fromDate:self];
    NSInteger day = [components day];
    return day;
    
}
@end

@implementation  NSDate (getMonthInteger)
-(NSInteger)getMonthInteger
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [calendar components:NSMonthCalendarUnit
                                               fromDate:self];
    NSInteger month = [components month];
    return month;
}
@end

@implementation NSDate (getYearInteger)

-(NSInteger)getYearInteger
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [calendar components:NSYearCalendarUnit
                                               fromDate:self];
    NSInteger year = [components year];
    return year;
    
}

@end

@implementation NSDate (dateByDayByYearByMonth)

+(NSDate*)setDateByComponentDay:(NSInteger)day byMonth:(NSInteger)month andByYear:(NSInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    return date;
}

@end

@implementation NSDate (dateByComponents)

-(NSDate*)setupWithComponentsDay:(unsigned int)day hour:(unsigned int)hour minute:(unsigned int)minute second:(unsigned int)second
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    
    [dateComponents setDay:day];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    
    return [gregorian dateFromComponents:dateComponents];

}

@end


