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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creamos la imageView programáticamente en lugar de con el storyboard
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    self.imageView = [[UIImageView alloc]init];
    [self.view addSubview:self.imageView];
    
    [PhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    // Cerramos la imagen al hacer tap en cualquier sitio
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    

}

- (void) close {
    // Método para cerrar la vista
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Método para cuando se crea la subvista (imageView)
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    // Centramos la imagen
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
    
}


@end
