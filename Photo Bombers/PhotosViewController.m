//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Alex Valladares on 19/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"

@interface PhotosViewController ()

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
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Creamos la clase para reutilizar los items, usando nuestra clase personalizada
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.title = @"Photo Bombers";
    
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
