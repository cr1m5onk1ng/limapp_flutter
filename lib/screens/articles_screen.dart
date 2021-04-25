import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:limapp/application/providers/database/database_providers.dart';
import 'package:limapp/application/providers/reader/reader_providers.dart';
import 'package:limapp/models/reader/article_hive.dart';
import 'package:limapp/screens/article_view.dart';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text(
          'Articles',
          style: TextStyle(
              fontFamily: 'Avenir', fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Article>('articles').listenable(),
              builder: (BuildContext context, Box<Article> box, Widget child) {
                final List<Article> articles = new List<Article>.of(box.values);
                if (articles.isEmpty) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        SizedBox(height: 200),
                        Text(
                          "No articles added.",
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Share a web page with Limapp",
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        )
                      ]),
                    ),
                  );
                }
                /*
                      articles
                          .sort((a, b) => -a.dateAdded.compareTo(b.dateAdded));
                      */
                return Container(
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ListTile(
                        leading: Container(
                          child: Image.network(
                            article.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            context
                                .read(databaseServiceProvider)
                                .deleteArticle(article);
                          },
                        ),
                        title: Text(
                          article.title,
                          style: TextStyle(fontFamily: 'Avenir', fontSize: 16),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          article.description,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ArticleView(
                                url: article.url,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
