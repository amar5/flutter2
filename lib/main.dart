import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; // Add this line.

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primaryColor: Colors.red,
        ),
        home: new RandomWords()
        );
  }


}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved(){
    print("PUSH");
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context){
          
          final Iterable<ListTile> tiles  = _saved.map((WordPair pair){
            return new ListTile(
              title: new Text(pair.asPascalCase, style: _biggerFont,),
            );
          });

          final List<Widget> divided = ListTile.divideTiles(
            context: context, tiles : tiles
          ).toList();

          return new Scaffold(
            appBar: AppBar(
              title: const Text('saved suggestions'),
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }
  
  @override // Add from this line ...
  Widget build(BuildContext context) {
    return new Scaffold(
          appBar: new AppBar(
            title: const Text("data"),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.list),
                onPressed: _pushSaved,
              )
            ],
          ),
          body:  _buildSuggestions(),
        );

  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  } // ... to this line.
}
