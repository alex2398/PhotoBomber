//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Alex Valladares on 19/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import <SimpleAuth/SimpleAuth.h>

@interface PhotosViewController ()

@property (strong, nonatomic) NSString *accessToken;

@end

@implementation PhotosViewController

// Sobreescribimos el método init para customizar el UICollectionViewLayout
- (instancetype) init {
    
    // Creamos el layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // Establecemos el tamaño de cada item
    layout.itemSize = CGSizeMake(106.0,106.0);
    // Establecemos el espacio entre items (horizontal)
    layout.minimumInteritemSpacing = 1.0;
    // Establecemos el espacio entre items (vertical)
    layout.minimumLineSpacing = 1.0;
    
    
    
    self = [super initWithCollectionViewLayout:layout];
    return self;
}
- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Bombers";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Creamos la clase para reutilizar los items, usando nuestra clase personalizada
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    
    /*
    // Conexion a url
    // Creamos la sharedSession, la url, el request y la downloadtask
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [[NSURL alloc]initWithString:@"http://blog.teamtreehouse.com/api/get_recent_summary/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // La response se guarda en el disco duro del movil, en la url location. Rescatamos el contenido con
        // NSString initWithContentOfURL
        NSString *text = [[NSString alloc]initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        // De momento solo logueamos la response
        NSLog(@"Response: %@",text);
    }];
    
    // Iniciamos la tarea de downloading con resume
    [task resume];
    */
    
    // Entramos con oAuth instagram
    
    // El accessToken debería guardarse en el keychain en lugar de en las preferencias
    // Ver más en https://github.com/soffes/sskeychain
    // http://stackoverflow.com/questions/26949605/using-keychain-to-store-username-after-login-xcode-6
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
    
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            NSLog(@"Response : %@", responseObject);
            // Obtenemos el token y lo guardamos como userDefaults (preferencias)
            NSString *accessToken = responseObject[@"credentials"][@"token"];
        
            [userDefaults setObject:accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
        }];
    } else {
        NSLog(@"Signed in!");
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/tags/cats/media/recent?access_token=%@",self.accessToken];
        NSURL *url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSString *text = [[NSString alloc]initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"Results : %@", text);
        }];
        [task resume];
        
}
    
    
}

// Retornamos 10 items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

@end
