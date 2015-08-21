//
//  PhotoCell.h
//  Photo Bombers
//
//  Created by Alex Valladares on 19/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSDictionary *photo;

@end
