import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/product_provider.dart';


class EditProductScreen extends StatefulWidget {
  final String id;
  const EditProductScreen({this.id});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading=false;

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var _initValue = {
    'title':'',
    'price':'',
    'imageUrl':'',
    'description':'',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    /*
    this function set values if we updating an old prod
     */
    if(widget.id!=null){
      _editedProduct = Provider.of<ProductProvider>(context,listen: false).findById(widget.id);
      _initValue = {
        'imageUrl':'',
        'title':_editedProduct.title,
        'description':_editedProduct.description,
        'price':_editedProduct.price.toString(),
      };
      _imageUrlController.text=_editedProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    /*
    this function is loading the image that user putted it's link.
     */
    if (!_imageUrlFocusNode.hasFocus) {
      if(!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')){
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async{
    /*
    this function is saving all values in the form
     */
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });
    if(_editedProduct.id!=null){
      await Provider.of<ProductProvider>(context,listen: false).updateProduct(_editedProduct.id,_editedProduct);
    }else{
      try{
        await Provider.of<ProductProvider>(context,listen: false).addProduct(_editedProduct);
      }catch(error){
        await showDialog<Null>(context: context,builder: (ctx)=>AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('ok'))
          ],
        ));
      }
    }
    setState(() {
      _isLoading=false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body:_isLoading? Center(child:CircularProgressIndicator(),) :Padding( //_isLoading? Center(child:CircularProgressIndicator(),) :
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                initialValue: _initValue['title'],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                    title: value,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                initialValue: _initValue['price'],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please provide a correct number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please provide a correct number2.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value),
                  );
                },
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  initialValue: _initValue['description'],
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters lang';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      title: _editedProduct.title,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                    );
                  },
                ),
                margin: EdgeInsets.only(bottom: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    //alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text(
                            'Enter a url',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please provide a valid url.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: value,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
