import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Sorting Visualizer',
      theme: ThemeData(
        // Application theme data, you can set the colors for the application as
        // you want
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sorting Visualizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<int> _numbers=[];
  int _sampleSize=500;

  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;
  _randomize(){
      _numbers=[];
   for(int i=0;i<_sampleSize;i++)
   {
       _numbers.add(Random().nextInt(_sampleSize));
   }
//   setState((){   }); 
_streamController.add(_numbers);
  }
   @override
   void initState(){
       super.initState();
       _streamController=StreamController<List<int>>();
       _stream=_streamController.stream;
       _randomize();

   }
  
  _sort() async{

  for (int i = 0; i < _numbers.length; i++) {
    for (int j = 0; j < _numbers.length-i-1; j++) {
      if (_numbers[j] > _numbers[j + 1]) {
        // Swapping using temporary variable
        int temp = _numbers[j];
        _numbers[j] = _numbers[j + 1];
        _numbers[j + 1] = temp;
      }
      await Future.delayed(Duration(microseconds:1));
      _streamController.add(_numbers); //setState((){});
    }
  }
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          child:StreamBuilder<Object>(
            stream:_stream,
            builder:(content,snapshot){
                int counter=0;
            return Row(
                children:_numbers.map((int number){
                counter++;
                return CustomPaint(
                    painter:BarPainter(
                        width:MediaQuery.of(context).size.width / _sampleSize,
                        value:number,
                        index:counter,
                    ),
                );
              }).toList(),
          );
        }
      ),
    ),
      bottomNavigationBar:Row(
          children:<Widget>[
              Expanded(
                  child:FlatButton(
                      child:Text("Randomize"),
                      onPressed:_randomize,
                  ),
              ),
              Expanded(
                  child:FlatButton(
                      child:Text("Sort"),
                      onPressed:_sort,
                ),
              ),
          ]
      )
    );
  }
}

class BarPainter extends CustomPainter{
      final double width;
        final int value;
        final int index; 
        BarPainter({this.width,this.value,this.index});
    @override
    void paint(Canvas canvas, Size size){
      Paint paint=Paint();
      if (this.value < 500 * .10) {
      paint.color = Color(0xFFDEEDCF);
    } else if (this.value < 500 * .20) {
      paint.color = Color(0xFFBFE1B0);
    } else if (this.value < 500 * .30) {
      paint.color = Color(0xFF99D492);
    } else if (this.value < 500 * .40) {
      paint.color = Color(0xFF74C67A);
    } else if (this.value < 500 * .50) {
      paint.color = Color(0xFF56B870);
    } else if (this.value < 500 * .60) {
      paint.color = Color(0xFF39A96B);
    } else if (this.value < 500 * .70) {
      paint.color = Color(0xFF1D9A6C);
    } else if (this.value < 500 * .80) {
      paint.color = Color(0xFF188977);
    } else if (this.value < 500 * .90) {
      paint.color = Color(0xFF137177);
    } else {
      paint.color = Color(0xFF0E4D64);
    }
      paint.strokeWidth=width;
      paint.strokeCap=StrokeCap.round;

      canvas.drawLine(Offset(index*width,0),Offset(index*width,value.ceilToDouble()),paint);
    }
    @override 
    bool shouldRepaint(CustomPainter oldDelegate){
        return true;
    }
}