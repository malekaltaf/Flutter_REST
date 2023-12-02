import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Product.dart';

void main() => runApp(MyApp(products: fetchProducts()));

Future<List<Product>> fetchProducts() async {
  final apiUrl = 'https://dummyjson.com/products';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> productsData = data['products'];

    List<Product> products = productsData.map((productData) {
      return Product.fromJson(productData);
    }).toList();

    return products;
  } else {
    throw Exception('Failed to load data');
  }
}

class MyApp extends StatelessWidget {
    
    MyApp({Key? key, required this.products}) : super(key: key);
    
    final Future<List<Product>> products;
    
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Product Navigation demo home page', products:
          products),
          );
    }
  }

class MyHomePage extends StatelessWidget {
    MyHomePage({Key? key, required this.title,required this.products}) : super(key: key);

    final String title;
    //final Future<List<Product>> products;
    final Future<List<Product>> products;

    //final items = Product.getProducts();

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Product Navigation")),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if(snapshot.hasError) print(snapshot.error);

              return snapshot.hasData 
              ? ProductBoxList(
                items: snapshot.data!) 
                : Center(child: CircularProgressIndicator());
            },
          ),
        ));
    }
  }



  class ProductPage extends StatelessWidget {
    ProductPage({Key? key,required this.item}) : super(key: key);

    final Product item;

    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(title: Text(this.item.title),),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset(this.item.image,fit: Boxfit.fill),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Image.network(this.item.thumbnail,)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(this.item.title,style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        Text(this.item.description),
                        Text("Price: "+this.item.price.toString()),
                        RatingBox(),
                        buyPurchaseButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  class RatingBox extends StatefulWidget{
    _RatingBoxState createState() => _RatingBoxState();
  }

  class buyPurchaseButton extends StatelessWidget {
    Widget build(BuildContext context){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(onPressed: something, child: Text('Add to Cart')),
          ElevatedButton(onPressed: something, child: Text('Buy Now')),
      ],);
    }
    
      something() {}
  }

  class _RatingBoxState extends State<RatingBox> {
    int _rating = 0;

    void _setRatingAsOne() {
      setState(() {
        _rating = 1;
      });
    }

    void _setRatingAsTwo() {
      setState(() {
        _rating = 2;
      });
    }

    void _setRatingAsThree() {
      setState(() {
        _rating = 3;
      });
    }

    Widget build(BuildContext context) {
      double _size=20;
      print(_rating);

      return Row(
        mainAxisAlignment:  MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (_rating >=1 ? Icon(Icons.star, size: _size,) : 
              Icon(Icons.star_border, size: _size,)),
              color: Colors.red[500],
              onPressed: _setRatingAsOne,
              iconSize: _size,
            ),
          ),

          Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (_rating >=2 ? Icon(Icons.star, size: _size,) : 
              Icon(Icons.star_border, size: _size,)),
              color: Colors.red[500],
              onPressed: _setRatingAsTwo,
              iconSize: _size,
            ),
          ),


          Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (_rating >=3 ? Icon(Icons.star, size: _size,) : 
              Icon(Icons.star_border, size: _size,)),
              color: Colors.red[500],
              onPressed: _setRatingAsThree,
              iconSize: _size,
            ),
          ),      

        ],
      );
    }

  }

class ProductBox extends StatelessWidget{
  ProductBox({Key? key,required this.item}) : super(key: key);

  final Product item;

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(2),
      //height: 140,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 200,
              ),
              child: Image.network(this.item.thumbnail)),
            Expanded(
              child: Container(
                //padding: EdgeInsets.all(20),
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.item.title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(this.item.description),
                    Text("Price: "+this.item.price.toString()),
                    RatingBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductBoxList extends StatelessWidget {
  final List<Product> items;

  ProductBoxList({Key? key,required this.items});

  Widget build(BuildContext context) {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ProductBox(item: items[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(item: items[index]),
                ),
              );
            },
          );
        }
      );
  }
}