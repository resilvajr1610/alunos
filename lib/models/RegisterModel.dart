import '../utils/export.dart';

class RegisterModel{

  String _id="";
  String _doc="";

  RegisterModel();

  RegisterModel.fromSnapshot(DocumentSnapshot snapshot,String doc):_doc = snapshot[doc];

  RegisterModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.doc = documentSnapshot["cor"];
  }

  RegisterModel.createId(String collection){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference brands = db.collection(collection);
    this.id = brands.doc().id;
  }

  Map<String, dynamic> toMap(String item){
    Map<String, dynamic> map = {
      "id" : this.id,
      "school" : this.doc,
    };
    return map;
  }

  String get doc => _doc;

  set doc(String value) {
    _doc = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}