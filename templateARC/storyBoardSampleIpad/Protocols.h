//
//  Protocols.h
//  templateARC
//
//  Created by Mac Owner on 3/16/13.
//
//
#import "macros.h"
@class ObjectiveButtonClass;
@class ButtonObjectClass;
#ifndef templateARC_Protocols_h
#define templateARC_Protocols_h

@protocol MapDetailViewControllerDelegate

-(void)createButton:(ButtonTypes) buttonType  atCircleWithDate:(NSDate*)date;

-(void)setImageButton:(ButtonObjectClass*)button ForState:(ButtonStates)buttonState;

-(void)updateButtonSubobjective:(ObjectiveButtonClass*)button;

@end

@protocol MainMapViewControllerDelegate
-(void)createButtonAtZoomOutViewButtonType:(ButtonTypes) buttonType  at:(int)circle;
@end


#endif
