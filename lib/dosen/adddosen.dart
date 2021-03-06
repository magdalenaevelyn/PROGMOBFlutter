import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progmob_flutter/apiservices.dart';
import 'package:progmob_flutter/model.dart';
import 'package:image_picker/image_picker.dart';

// Menyimpan formnya
final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AddDosen extends StatefulWidget {
  AddDosen({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _AddDosenState createState() => _AddDosenState(title);
}

class _AddDosenState extends State<AddDosen> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final String title;
  _AddDosenState(this.title);
  bool isLoading = false;
  Dosen dosen = new Dosen();
  File _imageFile;

  // Select image from galery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formState,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.attribution_rounded),
                          labelText: "NIDN",
                          hintText: "Contoh: 0516118902",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)
                      ),
                      onSaved: (String value) {
                        this.dosen.nidn = value;
                      },
                    ),
                    SizedBox(height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: "Nama",
                          hintText: "Contoh: Argo Wibowo",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)
                      ),
                      onSaved: (String value) {
                        this.dosen.nama = value;
                      },
                    ),
                    SizedBox(height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.house),
                          labelText: "Alamat",
                          hintText: "Contoh: Jl. Magelang",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)
                      ),
                      onSaved: (String value) {
                        this.dosen.alamat = value;
                      },
                    ),
                    SizedBox(height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.email_rounded),
                          labelText: "Email",
                          hintText: "Contoh: argo@staff.ukdw.ac.id",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String value) {
                        this.dosen.email = value;
                      },
                    ),
                    SizedBox(height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.perm_identity_outlined),
                          labelText: "Gelar",
                          hintText: "Contoh: S.Kom.",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)
                      ),
                      onSaved: (String value) {
                        this.dosen.gelar = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Ternary Operation -> objek ? true : false atau else
                    _imageFile == null
                        ? Text("Silahkan memilih gambar terlebih dahulu")
                        : Image.file(
                      _imageFile,
                      fit: BoxFit.cover,
                      height: 300.0,
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      color: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.image, color: Colors.white,),
                          Text(
                            "Upload Foto",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      color: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Simpan Data"),
                              content: Text("Apakah Anda akan menyimpan data ini?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () async {
                                      _formState.currentState.save();
                                      setState(() => isLoading = true);
                                      this.dosen.nim_progmob = "72180180";
                                      // List<int> imageByte = _imageFile.readAsBytesSync();
                                      // this.mhs.foto = base64Encode(imageByte);
                                      ApiServices().createDosenWithFoto(this.dosen, _imageFile, _imageFile.path).then((isSuccess) {
                                        setState(() => isLoading = false);
                                        if (isSuccess) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                    child: Text("Ya")
                                ),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Tidak")
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Simpan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              // Center(
              //   child: CircularProgressIndicator(),
              // )
              isLoading
                  ? Stack(
                children: <Widget>[
                  // Opacity(
                  //   opacity: 0.3,
                  //   child: ModalBarrier(
                  //     dismissible: false,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              )
                  : Container(),
              SizedBox(
                height: 20,
              ),
            ],
          ),

        ),
      ),
    );
  }
}