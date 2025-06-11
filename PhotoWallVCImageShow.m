//
//  VCImageShow.m
//  PhotoWall
//
//  Created by xiaoli pop on 2025/6/3.
//

#import "VCImageShow.h"

@interface VCImageShow ()

@end

@implementation VCImageShow

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片展示";
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = [[UIScreen mainScreen] bounds];
    //方法2:
    //self.imageView.image = self.image;
    //方法3:
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"photo0%lu.jpg",(unsigned long)(self.imageTag - 100) ]];
    /*
     一个视图对象只能有一个根视图
     当我们把视图添加到新的父视图上时
     会从原来的父亲视图删除掉
     */
    [self.view addSubview:self.imageView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
