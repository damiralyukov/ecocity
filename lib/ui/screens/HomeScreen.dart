import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryOption = 'Бумага';
  String _selectedDistrictOption = 'Центральный';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {},
            fillColor: Colors.white,
            child: Icon(
              Icons.eco,
              size: 20.0,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            constraints: BoxConstraints(minWidth: 0),
            padding: EdgeInsets.symmetric(horizontal: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(4)
                )
            ),
          ),
          SizedBox(width: 5),
          Text(
            'ECOCITY',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8
          ),
          child: IconButton(
            icon: Icon(
              Icons.help_outline
            ),
            color: Colors.white,
            onPressed: () {

            },
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).primaryColor.withOpacity(0.9)
                    ],
                  stops: [0.1, 0.2]
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 35
                    ),
                    _buildList(context)
                  ],
                ),
              ),
            ),
          ),
        ]
    );
  }

  Widget _buildHeader(BuildContext context) {
    List<String> _categoryOptions = <String>['Бумага', 'Пластик', 'Батарейки'];
    List<String> _districtOptions = <String>[
      'Центральный',
      'Калининский',
      'Курчатовский',
      'ЧМЗ',
      'ЧТЗ',
      'Ленинский',
      'Советский',
      'Северо-запад'
    ];
    Size size = MediaQuery
        .of(context)
        .size;

    return Column(
      children: [
        Container(
          height: size.height * 0.18,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.18 - 27,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36)
                  ),
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              Positioned(
                bottom: 68,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  height: 54,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Theme
                                .of(context)
                                .primaryColor
                                .withOpacity(0.23)
                        )
                      ]
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _selectedCategoryOption,
                      onChanged: (String value) {
                        setState(() {
                          _selectedCategoryOption = value;
                        });
                      },
                      items: _categoryOptions.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  height: 54,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Theme
                                .of(context)
                                .primaryColor
                                .withOpacity(0.23)
                        )
                      ]
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _selectedDistrictOption,
                      onChanged: (String value) {
                        setState(() {
                          _selectedDistrictOption = value;
                        });
                      },
                      items: _districtOptions.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Container(
      child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore
              .instance
              .collection('items')
              .doc(_selectedCategoryOption)
              .collection(_selectedDistrictOption)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.data.docs.length == 0) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Text(
                      'Упс, здесь пока ничего нет...',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold
                      )
                    )
                  )
              );
            }

            return ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data.docs.map<Widget>((
                  DocumentSnapshot document) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          document['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(
                            document['address']
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Theme
                            .of(context)
                            .primaryColor),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            builder: (context) {
                              return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                          document['title'],
                                          style: Theme.of(context).textTheme.headline6.copyWith(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      enabled: false
                                    ),
                                    Divider(),
                                    ListTile(
                                      leading: Icon(Icons.phone, color: Theme
                                        .of(context)
                                        .primaryColor),
                                      title: Text('Связаться'),
                                      trailing: Icon(Icons.keyboard_arrow_right,
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                      onTap: () {

                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.map, color: Theme
                                          .of(context)
                                          .primaryColor),
                                      title: Text('Найти на карте'),
                                      trailing: Icon(Icons.keyboard_arrow_right,
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                      onTap: () {

                                      },
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}