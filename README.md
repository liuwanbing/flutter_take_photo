# flutter_拍照，选择相片，支持预览大图demo
flutter 写的一个拍照demo,使用第三方插件  image_picker: ^0.6.7+4


//功能代码
//isTakePhoto 用来判断选择的是拍照还是从相册选择图片
  Future getImage(bool isTakePhoto) async {

    Navigator.pop(context);//关掉弹出的选择拍照，相册提示框
    //获取照片或者拍照的方法，
    final pickedFile = await picker.getImage(source:isTakePhoto?ImageSource.camera:ImageSource.gallery);
    if(pickedFile != null){
      //刷新widget
      setState(() {
        //将图片添加到数组中
        _images.add(pickedFile.path);
      });
    }
  }
  
  
  
