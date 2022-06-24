import '../utils/export.dart';

class ListPresenceScreen extends StatefulWidget {
  const ListPresenceScreen({Key? key}) : super(key: key);

  @override
  State<ListPresenceScreen> createState() => _ListPresenceScreenState();
}

class _ListPresenceScreenState extends State<ListPresenceScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  final _controllerSearch = TextEditingController();
  final _controllerItem = TextEditingController();
  RegisterModel _registerModel = RegisterModel();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResults = [];
  List _resultsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future? resultsLoaded;

  _deleteItem(String id){
    db
        .collection('listHistory')
        .doc(id)
        .delete().then((value) => Navigator.pushReplacementNamed(context, "/list-presence"));
  }

  _data() async {
    var data = await db.collection("listHistory").get();

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
        title: TextCustom(text: 'REGISTROS',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: width*0.07),
                Input(
                  widthCustom: 0.7,
                  controller: _controllerSearch,
                  hint: 'Pesquisar',
                  icons: Icons.search,
                  colorIcon: PaletteColor.primaryColor,
                  sizeIcon: 25.0,
                  background: PaletteColor.white,
                  colorBorder: PaletteColor.greyBorder,
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
                            child: TextCustom(text: 'Nenhuma registro salvo!',size: 20.0)
                        );
                      }else {
                        return ListView.builder(
                            itemCount: _resultsList.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _resultsList[index];

                              String id = item["id"];

                              return ItemList(
                                text: id,
                                onTapDelete: ()=>_deleteItem(id),
                                onTapEdit: ()=> Navigator.pushNamed(context, "/register-presence",arguments: id),
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
