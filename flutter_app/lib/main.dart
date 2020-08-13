
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterapp/show_image_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  //保存照片数组
  List<String> _images = [];
  final picker = ImagePicker();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('拍照,获取图片demo'),
      ),

      body: Center(
        child:Wrap(
          spacing: 5,
          runSpacing: 5,
          children: _getImagesWidget(),//返回一个widget数组
        ),
      ),
      //点击添加图片按钮
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,//点击弹出选择界面
        tooltip: '拍照',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  //模态弹出拍照，从相册选择界面，返回一个widget
  _pickImage(){
   return showModalBottomSheet(context: context, builder: (context)=>Container(
      height: 160,
      child: Column(
        children: <Widget>[
          _item('拍照',true),
          _item('从相册选择',false),
        ],
      ),
    ));
  }

  //拍照按钮和从相册选择按钮
  _item(String title,bool isTakePhoto){
    return GestureDetector(
      onTap: (){
         getImage(isTakePhoto);//获取图片路径，并添加到数组中
      },
      //设置按钮
      child:ListTile(
        leading: Icon(isTakePhoto?Icons.photo_camera:Icons.photo_library),
        title: Text(title),
      ) ,
    );
  }

  //将获取的图片路径展示到界面上
  _getImagesWidget(){
    //遍历照片数组返回每个显示图片的widget
    return  _images.map((filePath){
      return Stack(
        children: <Widget>[
          //圆角效果的图片
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: GestureDetector(
              onTap: (){
                //跳转到预览图片页面
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return ShowImagePage(filePath);
                }));
              },
              child: Image.file(File(filePath),width: 120, height: 90, fit: BoxFit.fill),
            ),
          ),

          //图片上的删除按钮
          Positioned(
            right: 3,
            top: 3,
            child: GestureDetector(
              onTap:(){
                setState(() {
                  _images.remove(filePath); //删除图片
                });
              } ,
              child: ClipOval(
                //圆角删除按钮
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(color: Colors.black45),
                  child: Icon(Icons.close,size: 18,color: Colors.white,),
                ),
              ),
            ),
          )
        ],
      );
    }).toList();
  }
}
