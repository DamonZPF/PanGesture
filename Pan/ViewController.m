//
//  ViewController.m
//  Pan
//
//  Created by zhoupengfei on 16/3/10.
//  Copyright © 2016年 zpf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,weak)UIView * letfView;
@property(nonatomic,weak)UIView * rightView;
@property(nonatomic,weak)UIView * mainView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupChildView];
    
    [_mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSLog(@"%@",NSStringFromCGRect(_mainView.frame));
    
    if (_mainView.frame.origin.x > 0) {
        self.rightView.hidden = YES;
    }else{
        self.rightView.hidden = NO;
    }
}

- (void)dealloc
{
    [_mainView removeObserver:self forKeyPath:@"frame"];
}

-(void)setupChildView{

    UIView * letfView  = [[UIView alloc] initWithFrame:self.view.bounds];
    
    letfView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:letfView];
    _letfView = letfView;
    
    UIView * rightView  = [[UIView alloc] initWithFrame:self.view.bounds];
    
    rightView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:rightView];
    _rightView = rightView;
    
    
    UIView * mainView  = [[UIView alloc] initWithFrame:self.view.bounds];
    
    mainView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:mainView];
    _mainView = mainView;
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}
#define   kScreenW [UIScreen mainScreen].bounds.size.width

-(void)pan:(UIPanGestureRecognizer*)pan{
    
    CGPoint transPoint = [pan translationInView:_mainView];

    _mainView.frame = [self framWithOffsetX:transPoint.x];
    
    [pan setTranslation:CGPointZero inView:_mainView];
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        CGFloat target = 0;
        if (_mainView.frame.origin.x > kScreenW* 0.5 ) {//定位到右边
            target = 230;
        }else if (CGRectGetMaxX(_mainView.frame) < kScreenW * 0.5){//定位到左边
            target = -230;
        }
        
        CGFloat offsetX = target - _mainView.frame.origin.x;
        
        [UIView animateWithDuration:0.05 animations:^{
            _mainView.frame = (target == 0) ? self.view.bounds : [self framWithOffsetX:offsetX];
        }];
    }
  
    
}

-(void)tap:(UITapGestureRecognizer*)tap{
    if (self.mainView.frame.origin.x !=0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.mainView.frame = self.view.bounds;
        }];
    }
}

#define kMaxY 100

-(CGRect)framWithOffsetX:(CGFloat)offsetX{
   __block CGRect mainViewFrame = self.mainView.frame;
    
  //  CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    //x轴偏移 Y 轴一起偏移量
    CGFloat offsetY = offsetX * kMaxY / screenH;
    //当前的高度
    CGFloat currentH = mainViewFrame.size.height - 2* offsetY;
    if (mainViewFrame.origin.x < 0) { //像左移动
        currentH = mainViewFrame.size.height + 2 * offsetY;
    }
    
    //当前高度的缩放比
    CGFloat scale = currentH / mainViewFrame.size.height;
    //根据缩放比获取当前的宽度
    CGFloat currentW = mainViewFrame.size.width * scale;
    //当前X 轴的位置
    CGFloat currentX = mainViewFrame.origin.x + offsetX;
    //当前Y轴的位置
    CGFloat currentY = (screenH - currentH)/2;
    
    mainViewFrame = CGRectMake(currentX, currentY, currentW, currentH);
    return mainViewFrame;
    
}



@end
