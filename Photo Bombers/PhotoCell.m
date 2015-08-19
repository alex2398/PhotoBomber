//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Alex Valladares on 19/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PhotoCell.h"


@implementation PhotoCell

// Inicializador (no se crea automáticamente en xcode 5)
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        // Establecemos la imagen para la celda
        self.imageView.image = [UIImage imageNamed:@"Treehouse"];
        // Añadimos la imagen al contentView (contenedor principal, en este caso la celda)
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // Hacemos que la imagen ocupe toda la celda
    self.imageView.frame = self.contentView.bounds;
    
}

@end
