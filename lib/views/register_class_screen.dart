import '../utils/export.dart';

class RegisterClassScreen extends StatefulWidget {
  const RegisterClassScreen({Key? key}) : super(key: key);

  @override
  State<RegisterClassScreen> createState() => _RegisterClassScreenState();
}

class _RegisterClassScreenState extends State<RegisterClassScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  final _controllerSearch = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResults = [];
  List _resultsList = [];
  Future? resultsLoaded;

  // _deleteItem(){
  //   db
  //       .collection('class')
  //       .doc(item)
  //       .delete().then((value){
  //     db
  //         .collection('classSearch')
  //         .doc(id)
  //         .delete().then((value) => Navigator.pushReplacementNamed(context, "/register-student"));
  //
  //   });
  // }

  _data() async {
    var data = await db.collection("classList").get();

    setState(() {
      _allResults = data.docs;
      print(_allResults.length);
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
        var brands = RegisterModel.fromSnapshot(items,'class').doc.toLowerCase();

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
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'TURMA',size: 20,color: PaletteColor.white,),
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
                ),
                SizedBox(width: width*0.05),
                AddButtom(onPressed: ()=>Navigator.pushNamed(context,"/register-student"),
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
                            child: Text('Sem dados!',style: TextStyle(fontSize: 20),)
                        );
                      }else {
                        return ListView.builder(
                            itemCount: _resultsList.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _resultsList[index];

                              String id = item['id'];

                              return ItemList(
                                text: id,
                                onTapDelete: (){},
                                onTapEdit: ()=>Navigator.pushNamed(context,"/register-student"),
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
