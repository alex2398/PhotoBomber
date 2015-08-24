//
//  PhotoController.m
//  Photo Bombers
//
//  Created by Alex Valladares on 24/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PhotoController.h"
#import <SAMCache.h>


@implementation PhotoController

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion {
    // Si algún parámetro es nil, no hacemos nada, para que no falle
    if (photo == nil | size == nil | completion == nil) {
        return;
    }
    // Para almacenar imagenes en la cache usamos 3rd party SAMCache
    // Para almacenar en cache, obtenemos un identificado, en este caso la key de la foto con la cadena thumbnail despues
    NSString *key = [[NSString alloc]initWithFormat:@"%@-%@",photo[@"id"],size];
    // Comprobamos si la key está ya en la caché, si es así la usamos y salimos
    UIImage *image = [[SAMCache sharedCache]imageForKey:key];
    if (image) {
        completion(image);
        return;
    }
    NSURL *url = [[NSURL alloc]initWithString:photo[@"images"][size][@"url"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        // Después de bajarla la guardamos en la caché
        [[SAMCache sharedCache]setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];
}


@end
