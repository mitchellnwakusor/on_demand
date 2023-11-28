import 'package:flutter/material.dart';
import 'package:on_demand/Services/local_database.dart';
import 'package:on_demand/Utilities/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const id = 'search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String? selectedOccupation;
  List<String> searchResults = [];

  void searchForOccupation(String keyword) async{
    List<String> result = [];
    //gets database
    var database = await LocalDatabase.instance.database;
    //query database for keyword
    var query = await database.query('occupation',columns: ['name'],where: 'name LIKE ?',whereArgs: ['%$keyword%'],orderBy: 'name ASC');
    if(query.isNotEmpty){
      //add map value to result list
      for (Map occupation in query) {
        occupation.forEach((key, value) {
          result.add(value);
          });
        }
      }
      searchResults = result;
      setState(() {});
  }


  @override
  void initState() {
    //run initial search for all items in database
    searchForOccupation('');
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Occupation'),
      ),
      body:  Padding(
        padding: kMobileBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                hintText: 'search occupation'
              ),
              controller: searchController,
              autofocus: true,
              onChanged: (value){
                searchForOccupation(value);
              },
              onEditingComplete: (){
                // on input - done select first item in search result if not empty
                if(searchController.text.length >1 && searchResults.isNotEmpty){
                  selectedOccupation = searchResults.first;
                  Navigator.pop(context,selectedOccupation);
                }
              },
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext _,int index){
                    return ListTile(
                    style: ListTileStyle.list,
                    title: Text(searchResults[index]),
                    onTap: () {
                      selectedOccupation = searchResults[index];
                      Navigator.pop(context,selectedOccupation);
                    } // pop screen and return search result
                  );
                  },
                  separatorBuilder: (BuildContext _,int index) => const Divider(color: Colors.black87,height: 8,),
                  itemCount: searchResults.length)
            )
          ],
        ),
      ),
    );
  }
}
