//
//  UIView+AnchorPoint.m
//  templateARC
//
//  Created by Mac Owner on 6/29/13.
//
//

#import "UIView+AnchorPoint.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (anchorPoint)

-(void)setNewUserAnchorPoint:(CGPoint)anchorPoint{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}


@end
