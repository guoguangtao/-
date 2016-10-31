//
//  InfinitudeView.m
//  无限轮播器
//
//  Created by ggt on 2016/10/30.
//  Copyright © 2016年 GGT. All rights reserved.
//  无限轮播器

#import "InfinitudeView.h"
#import "UIImageView+WebCache.h"

@interface InfinitudeView ()

@property (nonatomic, weak) UIImageView *imgView; /**< 图片容器 */
@property (nonatomic, assign) NSInteger index; /**< 图片索引 */
@property (nonatomic, assign) NSInteger imageCount; /**< 图片数量 */
@property (nonatomic, strong) NSTimer *timer; /**< 定时器 */
@property (nonatomic, weak) UILabel *showCountLabel; /**< 显示索引 */

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGesture; /**< 左滑手势 */
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGesture; /**< 右滑手势 */

@end

@implementation InfinitudeView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.275 green:0.350 blue:0.159 alpha:0.223];
        [self createdUI];
        [self addGuesture];
    }
    
    return self;
}

/**
 *  UI界面
 */
- (void)createdUI {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];
    self.imgView = imgView;
    
    UILabel *showCountLabel = [[UILabel alloc] init];
    [self addSubview:showCountLabel];
    self.showCountLabel = showCountLabel;
    showCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    showCountLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:showCountLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20],
                           [NSLayoutConstraint constraintWithItem:showCountLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20]]];
}

/**
 *  根据图片数组设置图片
 *
 *  @param imageArray 图片数组
 */
- (void)setImageArray:(NSArray *)imageArray {
    
    _imageArray = imageArray;
    _imageCount = imageArray.count;
    _index = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [self setImage];
}

/**
 *  根据手势设置图片
 */
- (void)setImageWithIndex:(NSInteger)index {
    
    if (index > _imageCount - 1) {
        _index = 0;
    } else if (index < 0) {
        _index = _imageCount - 1;
    }
    
    [self setImage];
}

/**
 *  设置图片
 */
- (void)setImage {
    
    // 显示图片索引
    [self setShowCountLabelText];
    id object = [_imageArray firstObject];
    // 如果传入的是图片则直接显示图片，如果是图片链接，网络加载
    if ([object isKindOfClass:[UIImage class]]) {
        _imgView.image = _imageArray[_index];
    } else if ([object isKindOfClass:[NSMutableString class]]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_imageArray[_index]]];
    }
}

/**
 *  添加手势
 */
- (void)addGuesture {
    
    // 1.添加左滑动手势
    _leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMethod:)];
    _leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_leftSwipeGesture];
    
    // 2.添加右滑动手势
    _rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMethod:)];
    _rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_rightSwipeGesture];
}

/**
 *  手势响应方法
 *
 *  @param swipeGesture 响应的手势
 */
- (void)gestureMethod:(UISwipeGestureRecognizer *)swipeGesture {
    
    [_timer invalidate];
    switch (swipeGesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            _index++;
            [self setImageWithIndex:_index];
            [self animationTransitionWithSwipeGestureRecognizerDirection:swipeGesture.direction];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            _index--;
            [self setImageWithIndex:_index];
            [self animationTransitionWithSwipeGestureRecognizerDirection:swipeGesture.direction];
            break;
        default:break;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

/**
 *  显示索引
 */
- (void)setShowCountLabelText {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd", _index + 1] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.915 green:0.685 blue:0.574 alpha:1.000]}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%zd", _imageCount] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [attributedString appendAttributedString:str1];
    [attributedString appendAttributedString:str2];
    _showCountLabel.attributedText = attributedString;
}

/**
 *  添加转场动画
 *
 *  @param direction 手势方向
 */
- (void)animationTransitionWithSwipeGestureRecognizerDirection:(UISwipeGestureRecognizerDirection)direction {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    // 设置动画的样式
    transition.type = kCATransitionPush;
    if (direction == UISwipeGestureRecognizerDirectionRight) {
        transition.subtype = @"fromLeft";
    } else {
        transition.subtype = @"fromRight";
    }
    [_imgView.layer addAnimation:transition forKey:nil];
}

/**
 *  定时器响应方法
 */
- (void)timerMethod {

    _index++;
    [self setImageWithIndex:_index];
    [self animationTransitionWithSwipeGestureRecognizerDirection:_leftSwipeGesture.direction];
}

@end
