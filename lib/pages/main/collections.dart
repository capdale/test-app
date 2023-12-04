import 'package:flutter/material.dart';
import 'package:modak/modak.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/collection_provier.dart';
import 'package:test_app/provider/modak_provider.dart';
import 'package:test_app/view_models/collection.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionsState();
}

class _CollectionsState extends State<CollectionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Modak modak = context.read<ModakChangeNotifier>().modak!;
    return Material(
      child: FutureBuilder(
          future: getCollectionInfoFromStorage(modak),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data!.collections.isEmpty) {
              return const Icon(Icons.no_cell_rounded);
            }
            print("go to widget");
            return ListenableProvider(
              create: (_) => CollectionChangeNotifier(),
              child: CollectionGridWidget(
                collections: snapshot.data!,
              ),
            );
          }),
    );
  }
}

class CollectionGridWidget extends StatefulWidget {
  final Collections collections;
  CollectionGridWidget({Key? key, required this.collections}) : super(key: key);

  @override
  State<CollectionGridWidget> createState() => _CollectionGridWidgetState();
}

class _CollectionGridWidgetState extends State<CollectionGridWidget> {
  @override
  Widget build(BuildContext context) {
    context.read<CollectionChangeNotifier>().setCollections(widget.collections);
    return Consumer<CollectionChangeNotifier>(builder: (_, data, __) {
      if (data.collections.collections.isEmpty) {
        return Text("collection is empty");
      }
      print(data.collections);
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: data.collections.collections.length,
        itemBuilder: (BuildContext context, int index) {
          final collection = data.collections.collections[index];
          return CollectionWidget(collection: collection);
        },
      );
    });
  }
}

class CollectionWidget extends StatefulWidget {
  final Collection collection;
  CollectionWidget({Key? key, required this.collection}) : super(key: key);

  @override
  State<CollectionWidget> createState() => _CollectionWidgetState();
}

class _CollectionWidgetState extends State<CollectionWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCollectionImageFile(
          widget.collection, context.read<ModakChangeNotifier>().modak!),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.warning);
        }
        return TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Material(
                      child: Column(
                        children: [
                          Hero(
                            tag: widget.collection,
                            child: Image(
                              image: FileImage(snapshot.data),
                            ),
                          ),
                          Text("Longtitude: ${widget.collection.longtitude}"),
                          Text("Altitude: ${widget.collection.altitude}"),
                          Text("Latitude: ${widget.collection.latitude}"),
                          Text("Time: ${widget.collection.originAt}"),
                          Text("Index: ${widget.collection.index}")
                        ],
                      ),
                    )));
          },
          child: Hero(
            tag: widget.collection,
            child: Image(
              image: FileImage(snapshot.data),
            ),
          ),
        );
      },
    );
  }
}
