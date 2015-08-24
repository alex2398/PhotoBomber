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
#import "DetailViewController.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"

@interface PhotosViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSArray *photos;

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
    
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            NSLog(@"Response : %@", responseObject);
            // Obtenemos el token y lo guardamos como userDefaults (preferencias)
            self.accessToken = responseObject[@"credentials"][@"token"];
        
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
        }];
    } else {
        [self refresh];
    }
}

// Retornamos 10 items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    // Obtenemos la foto guardada del json y la asignamos a la celda actual, esto para cada celda de la colección
    cell.photo = [self.photos objectAtIndex:indexPath.row];
    return cell;
}

- (void)refresh {
    NSLog(@"Signed in!");
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/tags/squats/media/recent?access_token=%@",self.accessToken];
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        // Sacamos el campo que nos interesa del JSON en un array
        // Para acceder a los subcampos del json lo hacemos con valueForKeyPath
        
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        // Cuando se llama SessionDownloadTask, se hace en background, por lo que volvemos a la hebra principal
        // para actualizar el collectionView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}

// Método para cuando seleccionamos un ítem del collectionView
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Seleccionamos la foto pulsada
    NSDictionary *photo = self.photos[indexPath.row];
    // Instanciamos el viewController para cambiar la propiedad
    DetailViewController *viewController = [[DetailViewController alloc]init];
    // Establecemos el modo de presentacion a Custom porque vamos a usar una transicion propia
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    // Le indicamos la transicion a usar
    viewController.transitioningDelegate = self;
    
    // Asignamos la propiedad
    viewController.photo = photo;
    
    // Establecemos qué hacer cuando aparece el viewController con el método presentViewController
    [self presentViewController:viewController animated:YES completion:nil];
    
}

// Dos métodos que sobreescribimos para las animaciones

// El que presenta
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PresentDetailTransition alloc] init];
}

// El que la elimina
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissDetailTransition alloc] init];
}



@end
