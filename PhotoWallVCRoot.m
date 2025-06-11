//
//  VCRoot.m
//  PhotoWall
//
//  Created by xiaoli pop on 2025/6/3.
//
/*
    userInteractionEnabled是UIView的一个重要属性，用于控制用户是否能与该视图及其子视图进行交互（如点击、滑动、手势等）。在照片墙案，若需要对图片进行点击查看、缩放、删除等操作，必须将相关视图的该属性设为 YES（默认值也是 YES，但某些场景下可能被意外修改）。
 */

#import "VCRoot.h"
#import "VCImageShow.h"
@interface VCRoot ()

@end

@implementation VCRoot

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片墙";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    //创建一个滚动视图并设置位置和画布大小
    UIScrollView* sv = [UIScrollView new];
    sv.frame = CGRectMake(5, 10, 394, 852);
    sv.contentSize = CGSizeMake(394, 852 * 1.5);
    sv.showsVerticalScrollIndicator = NO;
    //打开交互事件
    sv.userInteractionEnabled = YES;
    
    //利用循环给根视图上添加照片对象
    for (int i = 0; i < 9; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"photo0%d.jpg",i + 1]];
        UIImageView* view = [[UIImageView alloc] initWithImage:image];
        view.frame = CGRectMake(10 + (i % 3) * 125, (i / 3) * 165, 110, 150);
        [sv addSubview:view];
        view.userInteractionEnabled = YES;
        //创建点击手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTap:)];
        //单次点击
        tap.numberOfTapsRequired = 1;
        //单个手指
        tap.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tap];
        view.tag = 101 + i;
    }
    [self.view addSubview: sv];
}

//方法3:
- (void)pressTap:(UITapGestureRecognizer* )tap {
    UIImageView* imageView = (UIImageView*)tap.view;
    VCImageShow* imageshow = [VCImageShow new];
    imageshow.imageTag = imageView.tag;
    [self.navigationController pushViewController:imageshow animated:YES];
    
}


//方法2:
//- (void)pressTap:(UITapGestureRecognizer* )tap {
//    UIImageView* imageView = (UIImageView*)tap.view;
//    //创建显示视图控制器
//    VCImageShow* imageshow = [[VCImageShow alloc] init];
//    //点击的图像视图赋值
//    //imageshow.imageView = imageView;//不可行
//    imageshow.image = imageView.image;
//    //将视图控制器推出
//    [self.navigationController pushViewController:imageshow animated:YES];
//    
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
