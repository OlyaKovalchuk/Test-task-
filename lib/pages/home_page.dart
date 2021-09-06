import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('File', style: TextStyle(color: Colors.white),),
          ),
          body: _buttonsItemMenu(),
        );
  }

  Widget _buttonsItemMenu() =>  Center( child: Padding( padding: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Text('File loading', style: Theme.of(context).textTheme.headline5,),
          Text('All files: 5 / No files', style: Theme.of(context).textTheme.subtitle1, ),
          Text('currently loading: 2', style: Theme.of(context).textTheme.subtitle2, ),
        SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/file');
              },
              child: Text('Menu Item')),
          ElevatedButton(
            onPressed: () {},
            child: Text('Save', style: TextStyle(color: Colors.white),),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Reset',  style: TextStyle(color: Colors.white),),
          ),
        ],
      )));
}
