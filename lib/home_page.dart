import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:tuticket/detalles_evento.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:animate_do/animate_do.dart';

class CustomImageLoader extends StatefulWidget {
  final String imageUrl;

  const CustomImageLoader({required this.imageUrl});

  @override
  _CustomImageLoaderState createState() => _CustomImageLoaderState();
}


class _CustomImageLoaderState extends State<CustomImageLoader> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetallesEvento(widget.imageUrl),
              ),
            );
          },
          child: GridTile(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.identity()..scale(isExpanded ? 1.1 : 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      CollectionReference collectionRef = firestore.collection('eventos');
      QuerySnapshot querySnapshot = await collectionRef.get();

      setState(() {
        documents = querySnapshot.docs;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú principal'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EVENTOS EN TU CIUDAD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'Descúbrelos ahora',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          documents.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    shrinkWrap: true,
                    itemCount: documents.length > 6 ? 6 : documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = documents[index];
                      String imageUrl = document['imagenEvento'];

                      return Padding(
                        padding: const EdgeInsets.all(05.0),
                        child: GridTile(
                          child: CustomImageLoader(imageUrl: imageUrl),
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
