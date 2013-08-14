//
//  CircleMonth.h
//  templateARC
//
//  Created by Mac Owner on 4/25/13.
//
//

#import <Foundation/Foundation.h>

@interface CircleMonth : NSObject

@property (strong,nonatomic) NSMutableArray *arrayFinanceCoordinatesToDrawButton;
@property (strong,nonatomic) NSMutableArray *arrayHealthCoordinatesToDrawButton;
@property (strong,nonatomic) NSMutableArray *arrayPrivateLifeCoordinatesToDrawButton;

@property (assign,nonatomic) CGPoint radius;
@property (assign,nonatomic) CGPoint centerOfCircle;
@property (strong,nonatomic) NSNumber *dayTag;
@property (strong,nonatomic) NSDate *dateOfCircle;

-(void)createArrayOfCoordinatesForDrawZoomOutButtonsWithRadius:(CGPoint)radius withStep:(int)step centerOfCircle:(CGPoint)centerOfCircle;


@end
