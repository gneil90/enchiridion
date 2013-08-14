//
//  OneFingerRotateGestureRecognizer.m
//  templateARC
//
//  Created by Mac Owner on 6/25/13.
//
//

#import "OneFingerRotateGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "MainMapViewController.h"

@implementation OneFingerRotateGestureRecognizer
{
    CGPoint m_locationBegan;
    int flagAngle;
}
-(id)init
{
    self=[super init];
    if (self)
    {
        //do additional setup here
    }
    return self;
}

double wrapd(double _val, double _min, double _max)
{
    if (((_val<0.0005)&&(_val>0))) return 0.0005;
    if ((_val>-0.0005)&&(_val<0)) return 0.0005;
    if(_val < _min) return _max - (_min - _val);
    if(_val > _max) return _min - (_max - _val);
    return _val;
}

-(void)reset
{
    [super reset];
}

 
 - (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)_event
 {
     //[super touchesBegan:touches withEvent:_event];
 if ( [[_event allTouches]count]==1)
 {
//if ([self state] == UIGestureRecognizerStatePossible)
    //[self setState:UIGestureRecognizerStateBegan];

 UITouch* touch = [touches anyObject];
     
 CGPoint location = [touch locationInView:self.viewToRotate];
 m_locationBegan = location;
 }
 else if ( [[_event allTouches]count]>1)
 {
  [self setState:UIGestureRecognizerStateFailed];
 }
 }
 
 
 
 - (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)_event
 {
     //[super touchesMoved:touches withEvent:_event];
 if ( [[_event allTouches]count]==1)
 {
     if ([self state] == UIGestureRecognizerStatePossible)
     {
         [self setState:UIGestureRecognizerStateBegan];
     }
     
     UITouch* touch = [touches anyObject];
     
     CGPoint location = [touch locationInView:self.viewToRotate];
 
    [self updateRotation:location];
 }
 else if ( [[_event allTouches]count]>1)
 {
     [self setState:UIGestureRecognizerStateFailed];
 }

 }
 
 - (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)_event
 {
    //[super touchesEnded:touches withEvent:_event];
 if ( [[_event allTouches]count]==1)
 {
     if ([self state] == UIGestureRecognizerStateChanged) {
         UITouch* touch = [touches anyObject];
         CGPoint location = [touch locationInView:self.viewToRotate];
         
         
          [self updateRotation:location];
         
         MainMapViewController *mainMap = (MainMapViewController*)self.delegate;
         
         if (!mainMap.isDetailViewOn)
         {
         [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
             self.viewToRotate.transform = CGAffineTransformRotate(self.viewToRotate.transform, self.m_currentAngle*4.5f*3.14f/180);
         } completion:^(BOOL finished){
             flagAngle=0;
         }];
         }
         [self setState:UIGestureRecognizerStateEnded];
        

     }
     else
     {
         [self setState:UIGestureRecognizerStateFailed];
     }
 }
 }
 
 
 - (float) updateRotation:(CGPoint)_location
 {
 float fromAngle = atan2(m_locationBegan.y-self.viewToRotate.center.y, m_locationBegan.x-self.viewToRotate.center.x);
 float toAngle = atan2(_location.y-self.viewToRotate.center.y, _location.x-self.viewToRotate.center.x);
 float newAngle=0.0f;
 flagAngle=1;
 newAngle = wrapd(toAngle - fromAngle, 0, 2*3.14);
 
 //определение направления раскрутки
 if (flagAngle==1)  {
     if (-fromAngle+toAngle<0)
         self.m_currentAngle=-1;
         else self.m_currentAngle=1;
    }
 
 //вращение
 
     self.viewToRotate.transform = CGAffineTransformRotate(self.viewToRotate.transform, newAngle);
 
 return newAngle;
 }


@end
