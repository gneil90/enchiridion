//
//  OneFingerRotateGestureRecognizer.h
//  templateARC
//
//  Created by Mac Owner on 6/25/13.
//
//

#import <UIKit/UIKit.h>

@interface OneFingerRotateGestureRecognizer : UIPanGestureRecognizer

@property (assign,nonatomic) CGFloat m_currentAngle;
@property (weak,nonatomic) UIView *viewToRotate;

@end
