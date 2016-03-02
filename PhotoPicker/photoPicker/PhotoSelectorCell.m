//
//  PhotoSelectorCell.m
//  PhotoPicker
//
//  Created by yangtao on 3/1/16.
//  Copyright © 2016 yangtao. All rights reserved.
//

#import "PhotoSelectorCell.h"
#import "Masonry.h"

@interface PhotoSelectorCell()
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *removeButton;
@end

@implementation PhotoSelectorCell


- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    if (_image != nil) {
        
      //  self.removeButton.hidden = NO;
        [self.addButton setBackgroundImage:image forState:UIControlStateNormal];
        
    }else {
    
        self.removeButton.hidden = YES;
        [self.addButton  setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState: UIControlStateNormal];
    }
}

- (void)deleteImage:(UIGestureRecognizer*)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
         self.removeButton.hidden = NO;
        //添加抖动动画
       [self startAnimation];
    }
}

#pragma mark- 开始抖动动画
- (void)startAnimation {
    
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle1),  @(angle2), @(angle1)];
    anim.duration = 0.25;
    
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.addButton.layer addAnimation:anim forKey:@"shake"];
}

#pragma mark- 停止抖动动画
- (void)stop {
    
    [self.addButton.layer removeAnimationForKey:@"shake"];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
      
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {

    UIButton *addButton = [[UIButton alloc] init];
    addButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [addButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加长按手势
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
    [addButton addGestureRecognizer:gesture];

    [self addSubview:addButton];
    self.addButton = addButton;

    
    UIButton *removeButton = [[UIButton alloc] init];
    removeButton.hidden = YES;
    [removeButton setBackgroundImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeButton];
    self.removeButton = removeButton;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    __weak __typeof(&*self)weakSelf = self;
   [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.height.equalTo(weakSelf);
       make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
   }];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-2);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(0);
    
    }];
    
}

- (void)addBtnClick {
    
    [self stop];
    if (!self.image) {//添加图片
        if ([self.PhotoCelldelegate respondsToSelector:@selector(photoDidAddSelector:)]) {
            [self.PhotoCelldelegate photoDidAddSelector:self];
        }
    }else {
        
        NSLog(@"点击放大");
    }
  
}

- (void)removeBtnClick {
    
    //停止动画
    [self stop];
    
    if ([self.PhotoCelldelegate respondsToSelector:@selector(photoDidRemoveSelector:)]) {
        [self.PhotoCelldelegate photoDidRemoveSelector:self];
    }
}
@end
