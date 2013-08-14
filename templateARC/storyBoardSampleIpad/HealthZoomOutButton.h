//
//  HealthZoomOutButton.h
//  templateARC
//
//  Created by Mac Owner on 3/16/13.
//
//

#import "ButtonObjectClass.h"
@class CoordinatesController;
@class CircleMonth;

@interface HealthZoomOutButton : ButtonObjectClass

@property (strong,nonatomic) CoordinatesController *coordinateDefault;
@property (strong,nonatomic) CoordinatesController *coordinateWithRune;

-(void)setupBackgroundImage;


@end
