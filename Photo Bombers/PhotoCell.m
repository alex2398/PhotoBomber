//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Alex Valladares on 19/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PhotoCell.h"
#import <SAMCache/SAMCache.h>


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
// Sobreescribimos el setter de la propiedad photo
-(void) setPhoto:(NSDictionary *)photo {
    _photo = photo;
    
    NSURL *url = [[NSURL alloc]initWithString:photo[@"images"][@"thumbnail"][@"url"]];
    [self downloadPhotoWithURL:url];
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // Hacemos que la imagen ocupe toda la celda
    self.imageView.frame = self.contentView.bounds;
    
}

- (void) downloadPhotoWithURL:(NSURL*)url {
    // Para almacenar imagenes en la cache usamos 3rd party SAMCache
    // Para almacenar en cache, obtenemos un identificado, en este caso la key de la foto con la cadena thumbnail despues
    NSString *key = [[NSString alloc]initWithFormat:@"%@-thumbnail",self.photo[@"id"]];
    // Comprobamos si la key está ya en la caché, si es así la usamos y salimos
    UIImage *photo = [[SAMCache sharedCache]imageForKey:key];
    if (photo) {
        self.imageView.image = photo;
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        // Después de bajarla la guardamos en la caché
        [[SAMCache sharedCache]setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }];
    [task resume];
}


@end
