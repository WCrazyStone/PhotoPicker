//
//  PhotoPickerController.m
//  PhotoPicker
//
//  Created by yangtao on 3/1/16.
//  Copyright © 2016 yangtao. All rights reserved.
//

#import "PhotoPickerController.h"
#import "PhotoSelectorCell.h"
#import "UIImage+Extension.h"
static NSString *Identifier = @"photoCollectionViewCell";

@interface PhotoPickerController ()<UICollectionViewDataSource,PhotoSelectorCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray* pictureImages;
@property (nonatomic, strong) UICollectionView* photoCollectionView;
@end

@implementation PhotoPickerController

- (NSMutableArray*)pictureImages {
    
    if (!_pictureImages) {
        _pictureImages = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _pictureImages;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {

    //添加子控件
    UICollectionViewFlowLayout *photoFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    photoFlowLayout.itemSize = CGSizeMake(80, 80);
    photoFlowLayout.minimumInteritemSpacing = 10;
    photoFlowLayout.minimumLineSpacing = 10;
    
    //设置与photoCollectionView的间距
    photoFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView* photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:photoFlowLayout];
    photoCollectionView.frame = [UIScreen mainScreen].bounds;
    [photoCollectionView registerClass:[PhotoSelectorCell class] forCellWithReuseIdentifier:Identifier];
    photoCollectionView.dataSource = self;
    photoCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:photoCollectionView];
    self.photoCollectionView = photoCollectionView;
    
}

#pragma UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.pictureImages.count + 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    //获取cell
    PhotoSelectorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.PhotoCelldelegate = self;
    
    //给属性赋值
    if (self.pictureImages.count == indexPath.item) {
        
        cell.image = nil;
    }else {
        
        cell.image = self.pictureImages[indexPath.item];
    }
    
    return cell;
}

#pragma PhotoSelectorCellDelegate
- (void)photoDidAddSelector:(PhotoSelectorCell *)cell {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photoDidRemoveSelector:(PhotoSelectorCell *)cell {
    
    //拿到对应的item
    NSIndexPath *index = [self.photoCollectionView indexPathForCell:cell];
    [self.pictureImages removeObjectAtIndex:index.item];
    
    [self.photoCollectionView reloadData];
}

#pragma UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    UIImage *newImage = [image imageWithScale:[UIScreen mainScreen].bounds.size.width];
    
    [self.pictureImages addObject:newImage];
    [self.photoCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
