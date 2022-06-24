import '../utils/export.dart';

class ListClassScreen extends StatefulWidget {
  const ListClassScreen({Key? key}) : super(key: key);

  @override
  State<ListClassScreen> createState() => _ListClassScreenState();
}

class _ListClassScreenState extends State<ListClassScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResults = [];

  _data() async {
    var data = await db.collection("classList").get();

    setState(() {
      _allResults = data.docs;
    });
    return "complete";
  }

  @override
  void initState() {
    super.initState();
    _data();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'TURMAS CADASTRADAS',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextCustom(text: 'Selecione uma turma para avançar',size: 20),
            SizedBox(height: 50),
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
                      if(_allResults.length == 0){
                        return Center(
                            child: TextCustom(text: 'Nenhuma turma cadastrada!',size: 20.0)
                        );
                      }else {
                        return ListView.builder(
                            itemCount: _allResults.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _allResults[index];

                              String id = item['id'];

                              return GestureDetector(
                                onTap: ()=>Navigator.pushReplacementNamed(context, "/register-presence",arguments: "CREATE "+id),
                                child: ItemList(
                                  text: id,
                                  onTapDelete:null,
                                  onTapEdit:null,
                                ),
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
