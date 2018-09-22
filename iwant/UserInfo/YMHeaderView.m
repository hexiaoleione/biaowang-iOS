//
//  YMHeaderView.m
//  photo
//
//  Created by DuZexu on 15/5/6.
//  Copyright (c) 2015年 Duzexu. All rights reserved.
//

#import "YMHeaderView.h"

@interface YMHeaderView ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIView *_view;
    CGFloat _currentScale;
}

@property (weak, nonatomic) UIViewController *superViewController;

@end

@implementation YMHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSelf];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width /2.0f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tap];
}

- (void)imageTaped:(UIGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", @"用摄像头拍照", @"查看大图",nil];
    [actionSheet showInView:self.superViewController.view];
}

#pragma mark- actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //从相册中选择
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.superViewController presentViewController:imagePickerController animated:YES completion:nil];
            break;
        }
        case 1:{
            //拍照获取
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.superViewController presentViewController:imagePickerController animated:YES completion:nil];
            }
            break;
        }
        case 2:{
            //拍照获取
            {
                _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.superViewController.view.frame.size.width, self.superViewController.view.frame.size.height)];
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.superViewController.view.frame.size.width, self.superViewController.view.frame.size.height)];
                _view.backgroundColor = [UIColor whiteColor];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
                [_view addGestureRecognizer:tap];
//                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
//                [imageV addGestureRecognizer:pinch];
                imageV.userInteractionEnabled= YES;
                imageV.image = self.image;
                imageV.contentMode = UIViewContentModeScaleAspectFit;
                [_view addSubview:imageV];
                _view.alpha = 0;
                _currentScale = 0.;
                [self.superViewController.view addSubview:_view];
                [UIView animateWithDuration:0.5 animations:^{
                    _view.alpha = 1;
                }];
                
                
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if ([_delagate respondsToSelector:@selector(headerView:didSelectWithImage:)]) {
        [_delagate headerView:self didSelectWithImage:image];
    }
    self.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter & Setter
- (UIViewController *)superViewController {
    if ([_delagate isKindOfClass:[UIViewController class]]) {
        _superViewController = (UIViewController *)_delagate;
    }
    return _superViewController;
}

#pragma mark- tapGesture

- (void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        _view.alpha = 0;
    } completion:^(BOOL finished) {
        [_view removeFromSuperview];
    }];
    
}
- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    NSLog(@"%f",pinch.scale);
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        pinch.view.transform =CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
        pinch.scale =1;
    }
}
@end
