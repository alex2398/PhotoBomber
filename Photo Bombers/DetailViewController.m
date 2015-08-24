//
//  DetailViewController.m
//  Photo Bombers
//
//  Created by Alex Valladares on 24/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creamos la imageView programáticamente en lugar de con el storyboard
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    // Establecemos la imagen fuera de los límites para hacer el snap animator (más abajo)
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, -320.0, 320.0f, 320.0f)];
    [self.view addSubview:self.imageView];
    
    [PhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    // Cerramos la imagen al hacer tap en cualquier sitio
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    
    // Establecemos el animador dinámico (físicas)
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Añadimos el animador snap
    // Lo añadimos en viewDidAppear para que tarde un poco más en aparecer la animación
    UISnapBehavior *behavior = [[UISnapBehavior alloc]initWithItem:self.imageView snapToPoint:self.view.center];
    [self.animator addBehavior:behavior];
    
}

- (void) close {
    
    [self.animator removeAllBehaviors];
    UISnapBehavior *behavior = [[UISnapBehavior alloc]initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.0f)];
    [self.animator addBehavior:behavior];

    // Método para cerrar la vista
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Método para cuando se crea la subvista (imageView)
// Lo comentamos porque lo hacemos con el dynamicAnimator
/*
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    // Centramos la imagen
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
    
}
*/

@end
