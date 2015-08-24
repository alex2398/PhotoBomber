//
//  DismissDetailTransition.m
//  Photo Bombers
//
//  Created by Alex Valladares on 24/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "DismissDetailTransition.h"

@implementation DismissDetailTransition


// Sobreescribimos el método transitionDuration y establecemos la duración de la transición a 0.3
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Creamos la animación
    
    // Creamos la vista de detalle
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // Animamos la transición
    [UIView animateWithDuration:0.3 animations:^{
        // Establecemos el alpha a 0 para que tenga efecto de fade-out (al contrario a como aparece)
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        // Lo eliminamos de la vista principal y completamos la transicion
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}



@end
