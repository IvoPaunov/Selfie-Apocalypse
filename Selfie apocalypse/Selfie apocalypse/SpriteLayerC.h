//
//  SpriteLayerC.h
//  Selfie apocalypse
//
//  Created by Ivko on 2/3/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface SpriteLayerC : CALayer {
    unsigned int sampleIndex;
    CABasicAnimation *currentAnimation;
}

@property (readwrite, nonatomic) unsigned int sampleIndex;
@property (readwrite, nonatomic) CABasicAnimation* currentAnimation;

+ (id) layerWithImageAndAnimationSettings: (UIImage *) img
                               sampleSize: (CGSize) size
                      animationFrameStart: (int) startFrame
                        animationFrameEnd: (int) endFrame
                        animationDuration: (float) duration
                    lanimationRepeatCount: (float) repeatCount;

- (id) initWithImageAndAnimationSettings: (UIImage *) img
                         sampleSize: (CGSize) size
                animationFrameStart: (int) startFrame
                  animationFrameEnd: (int) endFrame
                  animationDuration: (float) duration
              lanimationRepeatCount: (float) repeatCount;

- (void) playAnimationAgain;

+ (void) playAnimationAgain;

@end
