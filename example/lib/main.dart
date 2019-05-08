import 'package:flutter/material.dart';

import 'package:simple_cache/simple_cache.dart';

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
  SimpleCache simpleCache;
  String cacheData;
  String expireString;
  String currentTime;
  bool showResult = false;
  int expire = 20;
  final String cacheKey = 'simple.cache.key';
  Widget _buildCacheData(){
    return cacheData == null ? Container() : Text('缓存内容为：$cacheData');
  }
  Widget _buildExpireString(){
    return expireString == null ? Container() : Text('过期时间为：$expireString');
  }
  Widget _buildCurrentTime(){
    return currentTime == null ? Container() : Text('当前时间为：$currentTime');
  }
  Widget _buildResult(){
    return showResult == false ? Container() : Text('缓存已经失效', style: TextStyle(color: Colors.red, fontSize: 24.0),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildCacheData(),
              _buildResult(),
        _buildExpireString(),
        _buildCurrentTime(),
            SizedBox(height: 16.0,),
            Wrap(
              spacing: 20.0,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async{
                    String value = DateTime.now().toString();
                    simpleCache = await SimpleCache.getInstance();
                    await simpleCache.setEx(cacheKey, value, expire:  expire);
                    String _currentTime = DateTime.now().toString();
                    String _expireString = DateTime.now().add(Duration(seconds: expire)).toString();
                    setState(() {
                      cacheData = value;
                      expireString = _expireString;
                      currentTime = _currentTime;
                      showResult = false;
                    });
                  },
                  child: Text('写入缓存, $expire秒过期'),
                ),
                RaisedButton(
                  onPressed: (){
                    if(cacheData == null) return false;
                    String value = simpleCache.getEx(cacheKey);
                    String _currentTime = DateTime.now().toString();
                    setState(() {
                      cacheData = value;
                      currentTime = _currentTime;
                      showResult = (cacheData == null) ? true : false;
                    });
                  },
                  child: Text('获取缓存'),
                ),
                RaisedButton(
                  onPressed: (){
                    simpleCache.flush();
                    setState(() {
                      cacheData = null;
                      currentTime = null;
                      expireString = null;
                      showResult = false;
                    });
                  },
                  child: Text('清空缓存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
