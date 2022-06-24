import '../utils/export.dart';

class RegisterSchoolScreen extends StatefulWidget {
  const RegisterSchoolScreen({Key? key}) : super(key: key);

  @override
  State<RegisterSchoolScreen> createState() => _RegisterSchoolScreenState();
}

class _RegisterSchoolScreenState extends State<RegisterSchoolScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  final _controllerSearch = TextEditingController();
  final _controllerItem = TextEditingController();
  RegisterModel _registerModel = RegisterModel();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResults = [];
  List _resultsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future? resultsLoaded;

  _showDialog(String id, String item) {

    if(item==""){
      _controllerItem.clear();
    }else{
      _controllerItem.text = item;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          double width = MediaQuery.of(context).size.width;
          return ShowDialogCustom(
            title: item==""?'Cadastrar Escola':'Alterar Escola',
            listContent: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: 30,
                      width: 300,
                      child: TextCustom(text: 'Escola')
                  ),
                  Input(
                    obscure: false,
                    keyboardType: TextInputType.text,
                    controller: _controllerItem,
                    hint: 'Nome da Escola',
                    fonts: 20,
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
            list: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: width*0.22,
                height: 30,
                child: ButtonCustom(
                  onPressed: () => item==""?_saveFirebase():_updateItem(id,item,_controllerItem.text),
                    text: item==""?'Salvar':'Alterar',
                ),
              ),
              SizedBox(width: 20),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: width*0.22,
                height: 30,
                child: ButtonCustom(
                  onPressed: () => Navigator.pop(context),
                  text: 'Cancelar',
                  colorButton: PaletteColor.greyButtom,
                  colorBorder: PaletteColor.greyButtom,
                ),
              ),

            ],
          );
        });
  }

  _saveFirebase(){
    if(_controllerItem.text.isNotEmpty){
      _registerModel = RegisterModel.createId('schools');

      _registerModel.doc = _controllerItem.text;

      db
          .collection("schools")
          .doc(_registerModel.doc)
          .set(_registerModel.toMap('schools'))
          .then((value) {
          Navigator.pop(context);
          _controllerItem.clear();
          Navigator.pushReplacementNamed(context, "/register-school");
        });
    }else{
      setState(() {
        showSnackBar(context, "Nome da escola está vazio", _scaffoldKey);
      });
    }
  }

  _deleteItem(String id, String item){
    db
        .collection('schools')
        .doc(item)
        .delete().then((value) => Navigator.pushReplacementNamed(context, "/register-school"));
  }

  _updateItem(String id, String itemOld, String itemNew){
    if(_controllerItem.text.isNotEmpty) {
      db
          .collection('schools')
          .doc(itemOld)
          .delete().then((value) {
        db
            .collection('schools')
            .doc(itemNew)
            .set({
          'id': id,
          'school': itemNew
        })
            .then((value) =>
              Navigator.pushReplacementNamed(context, "/register-school"));
        });
    }else{
      setState(() {
        showSnackBar(context, "Nome da escola está vazio", _scaffoldKey);
      });
    }
  }

  _data() async {
    var data = await db.collection("schools").get();

    setState(() {
      _allResults = data.docs;
    });
    resultSearchList();
    return "complete";
  }

  _search() {
    resultSearchList();
  }

  resultSearchList() {
    var showResults = [];

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var brands = RegisterModel.fromSnapshot(items,'school').doc.toLowerCase();

        if (brands.contains(_controllerSearch.text.toLowerCase())) {
          showResults.add(items);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _data();
    _controllerSearch.addListener(_search);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSearch.removeListener(_search);
    _controllerSearch.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = _search();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'ESCOLA',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: width*0.07),
                Input(
                  controller: _controllerSearch,
                  hint: 'Pesquisar',
                  icons: Icons.search,
                  colorIcon: PaletteColor.primaryColor,
                  sizeIcon: 25.0,
                  background: PaletteColor.white,
                  colorBorder: PaletteColor.greyBorder,
                  inputFormatters: [],
                ),
                SizedBox(width: width*0.05),
                AddButtom(onPressed: ()=>_showDialog('',''),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: height * 0.5,
              child: StreamBuilder(
                stream: _controllerStream.stream,
                builder: (context, snapshot) {

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(_resultsList.length == 0){
                        return Center(
                            child: TextCustom(text: 'Nenhuma escola cadastrada!',size: 20.0)
                        );
                      }else {
                        return ListView.builder(
                            itemCount: _resultsList.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _resultsList[index];

                              String id = item["id"];
                              String school = item["school"];

                              return ItemList(
                                text: school,
                                onTapDelete: ()=>_deleteItem(id,school),
                                onTapEdit: ()=>_showDialog(id,school),
                              );
                            });
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
