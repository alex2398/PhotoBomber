//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Alex Valladares on 19/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoController.h"


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
        
        // Añadimos reconocer gestos Tap (toques)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}
// Sobreescribimos el setter de la propiedad photo
-(void) setPhoto:(NSDictionary *)photo {
    _photo = photo;
    
    
    [PhotoController imageForPhoto:photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // Hacemos que la imagen ocupe toda la celda
    self.imageView.frame = self.contentView.bounds;
    
}

-(void) like {
    // Primero guardamos el like en instagram con la api
    NSURLSession *session = [NSURLSession sharedSession];
    // Accedemos a las preferencias para coger el token que hemos guardado previamente en PhotosViewController
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    // Guardamos el like con un request (API)
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@",self.photo[@"id"],accessToken];
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    // Al ser un POST (creamos algo en lugar de obtener, como con GET), tenemos que usar NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
    }];
    [task resume];

}

-(void)showLikeCompletion {
    NSLog(@"Link : %@",self.photo[@"link"]);
    // Mostramos el mensaje en la pantalla (se llama al hacer doble tap)
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    // Generamos el tiempo que estará la alerta en pantalla (1 segundo)
    double delay_in_seconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay_in_seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });

}
@end
