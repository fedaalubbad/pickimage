import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      showSemanticsDebugger: false,
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
  File _image;
  final picker=ImagePicker();

// تنفذ عند اختيارأو التقاط الصورة
Future getImage(ImageSource src) async{
  final pickedFile= await picker.getImage(source: src);
  setState(() {
    if(pickedFile!=null){
      _image=File(pickedFile.path);
    }else {
      print('No Image selected!');
    }
  });

}
  List<Asset> images=List<Asset>();
  Future loadAssets() async{
    List<Asset>resultList=List<Asset>();
    try{
       resultList= await MultiImagePicker.pickImages(
           maxImages: 300,
           selectedAssets: images,
          enableCamera: true,
         materialOptions: MaterialOptions(
           actionBarColor: 'green',
           selectCircleStrokeColor: 'yellow'
         ),
       );
       setState(() {
         images=resultList;
       });
    }catch (e){
      print(e);
    }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
        actions: [
          FlatButton(
            child: Text('pick images'),
            onPressed: loadAssets,
          )

        ],
      ),

     body: Stack(
       children: [
      Column(
      children: [
        Container(
        child:_image==null ? Text('No Image selected')    //اذا ما في صورة يعرض نص
          :Image.file(_image,height: 100,width: 100,) ,         // هنا يعرض الصورة
        ),
    ],
    ),
         Container(
           margin: EdgeInsets.symmetric(vertical: 120),
           child: GridView.count(//عرض// multi images
             crossAxisCount: 3,
             children: List.generate(images.length, (index) {
               return AssetThumb(
                 asset: images[index],
                 width: 300,
                 height: 300,
               );
             }),
           ),
         ),
      ]),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          var ad =AlertDialog(
            title: Text('choose image from!'),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Divider(color: Colors.black,),
                  Container(
                    width: 300,
                    color: Colors.teal,
                    child: ListTile(
                      title: Text('Gallery'),
                      leading: Icon(Icons.image),
                      onTap: (){
                        Navigator.of(context).pop();
                        getImage(ImageSource.gallery);
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 300,
                    color: Colors.teal,
                    child: ListTile(
                      title: Text('Camera'),
                      leading: Icon(Icons.camera_alt),
                      onTap: (){
                        Navigator.of(context).pop();
                        getImage(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
          showDialog(context: context,child: ad);
        },
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
