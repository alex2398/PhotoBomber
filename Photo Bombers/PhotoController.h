//
//  PhotoController.h
//  Photo Bombers
//
//  Created by Alex Valladares on 24/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

// Refactor: Declaramos una clase para mostrar la imagen pasandole el diccionario con los datos de la foto
// y el tamaño deseado

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;


@end
