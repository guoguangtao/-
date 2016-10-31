//
//  ViewController.m
//  无限轮播器
//
//  Created by ggt on 2016/10/30.
//  Copyright © 2016年 GGT. All rights reserved.
//

#import "ViewController.h"
#import "InfinitudeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    InfinitudeView *infinitudeView = [[InfinitudeView alloc] initWithFrame:self.view.bounds];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i <= 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [imageArray addObject:image];
    }
    infinitudeView.imageArray = imageArray;
//    infinitudeView.imageArray = @[
//                                  @"http://static.zhidao.manmankan.com/kimages/201610/21_1477016730823241.png",
//                                  @"http://upload.cbg.cn/2016/0927/1474987590933.jpg",
//                                  @"http://imgsrc.baidu.com/forum/w%3D580/sign=7a34e02fb5003af34dbadc68052bc619/95d7432309f79052d4c547180ff3d7ca7acbd5b5.jpg"];
    [self.view addSubview:infinitudeView];
}


@end
