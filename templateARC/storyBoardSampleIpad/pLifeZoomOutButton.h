//
//  pLifeZoomOutButton.h
//  templateARC
//
//  Created by Mac Owner on 5/7/13.
//
//

#import "ButtonObjectClass.h"
@class CoordinatesController;

@interface pLifeZoomOutButton : ButtonObjectClass

@property (strong,nonatomic) CoordinatesController *coordinateDefault;
@property (strong,nonatomic) CoordinatesController *coordinateWithRune;

-(void)setupBackgroundImage;

@end
