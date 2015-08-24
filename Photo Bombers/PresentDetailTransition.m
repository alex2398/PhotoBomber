//
//  PresentDetailTransition.m
//  Photo Bombers
//
//  Created by Alex Valladares on 24/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PresentDetailTransition.h"

@implementation PresentDetailTransition


// Sobreescribimos el método transitionDuration y establecemos la duración de la transición a 0.3
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Creamos la animación
    
    // Creamos la vista de detalle (Depende si es ContextToViewControllerKey o ContextFromViewControllerKey indica si es en un sentido u otro (present o dismiss)
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // Creamos la vista contenedor
    UIView *containerView = [transitionContext containerView];
    detail.view.alpha = 0.0;
    // Hacemos que el detalle ocupe toda la pantalla
    // Nota: También hacemos que se desplace hacia abajo 20 puntos para que se pueda ver la barra
    CGRect frame = containerView.bounds;
    frame.origin.y += 20.0;
    frame.size.height -=20.0;
    
    detail.view.frame = frame;
    // Añadimos la vista
    [containerView addSubview:detail.view];
    
    // Animamos la transición
    [UIView animateWithDuration:0.3 animations:^{
        // Establecemos el alpha a 1 para que tenga efecto de fade-in
        detail.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}


@end
