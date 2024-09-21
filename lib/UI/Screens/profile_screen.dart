import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/Services/providers/signup_provider.dart';
import 'package:on_demand/Services/providers/user_details_provider.dart';
import 'package:on_demand/UI/Components/location_drop_down.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/portfolio_model.dart';
import 'package:provider/provider.dart';


class ArtisanProfileScreen extends StatefulWidget {
  const ArtisanProfileScreen({super.key});

  @override
  State<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> with SingleTickerProviderStateMixin{
  late TabController tabController;

  bool isPortfolio = false;
  bool isVerified = false;
  String name = 'blank';
  String occupation = 'blank';
  String location = 'blank';
  String priceRate = '0000';
  double rating = 4;
  String? rate;
  String? profilePicture;

  List<ArtisanPortfolio> portfolioData = [];


  @override
  void initState() {
    var fName = Provider.of<UserDetailsProvider>(context,listen: false).firstName;
    var lName = Provider.of<UserDetailsProvider>(context,listen: false).lastName;
    name = '$fName $lName';
    occupation = Provider.of<UserDetailsProvider>(context,listen: false).occupation;
    location = Provider.of<UserDetailsProvider>(context,listen: false).location;
    var rAte = Provider.of<UserDetailsProvider>(context,listen: false).rate;
    var profilePic = Provider.of<UserDetailsProvider>(context,listen: false).profilePicture;

    if(profilePic == null){
      profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
    }else{
      profilePicture='$profilePic';
    }

    if(rAte == null){
      rate = priceRate;
    }else{
      rate='$rAte';
    }


    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if(tabController.index==1 || (tabController.indexIsChanging && tabController.index==1)){
        setState(() {
          isPortfolio = true;
        });
      }
      else{
        setState(() {
          isPortfolio = false;
        });
      }
    });
    super.initState();
  }

  List<Widget> _buildPortfolioWidget(List<ArtisanPortfolio> portfolioList) {
    List<Widget> widgetList = [];
    for(ArtisanPortfolio p in portfolioList){
      widgetList.add(
        PortfolioWidget(title: p.title, imageURL: p.imageURL, uploadDate: p.uploadDate)
      );
    }
    return widgetList;
  }

  @override
  void dispose() {
      tabController.dispose();
      super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Profile'),
        actions: [Visibility(visible: isPortfolio,child: IconButton(onPressed: ()=>Navigator.pushNamed(context, addPortfolioScreen), icon: const Icon(Icons.add)))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context,constraints){
            return ConstrainedBox(
              constraints: constraints,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 InkWell(
                                     onTap: showProfilePicture,
                                     child: CircleAvatar(radius: 40,backgroundImage: NetworkImage('$profilePicture'),),

                                 ),
                                const SizedBox(height: 8,),
                                Column(
                                  children: [
                                    isVerified ? const Icon(Icons.verified,color: Colors.green,) : const Icon(Icons.verified_outlined,color: Colors.red,),
                                    const SizedBox(width: 8,),
                                    isVerified ? const Text('Verified') : const Text('Unverified')
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(name,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18,),),
                                const SizedBox(height: 8,),
                                Text(occupation,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                                const SizedBox(height: 8,),
                                Text(location,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                                const SizedBox(height: 8,),
                                RatingBarIndicator(
                                  itemBuilder: (context,number){
                                    return const Icon(Icons.star);
                                  },
                                  itemPadding: EdgeInsets.zero,
                                  itemCount: 5,
                                  itemSize: 20,
                                  rating: rating,


                                )

                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("₦$rate",style: const TextStyle(letterSpacing: 0,fontWeight: FontWeight.w600,fontSize: 18),),
                                const SizedBox(height: 48,),
                                ElevatedButton(onPressed: () => Navigator.pushNamed(context, editProfileScreen), child: const Text('Edit')),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8,),
                    TabBar(
                        controller: tabController,
                        tabs: const [
                          Tab(text: 'Recent jobs',),
                          Tab(text: 'Portfolio',),
                        ]),
                    Expanded(
                      child: TabBarView(
                          controller: tabController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: const Color(0xfff2f2f2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(vertical: 16),
                                    child: const Text('No job requests yet',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18
                                      ),),
                                  ),
                                ],),
                            ),
                            StreamBuilder(
                              stream: FirebaseDatabase.getPortfolioDataStream(), //get artisan portfolio
                              builder: (context,snapshot){
                                  if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                                    List<ArtisanPortfolio> tempPortfolioData= [];
                                    //get list of documents
                                    List<QueryDocumentSnapshot<Map<String,dynamic>>> documents = snapshot.data!.docs;
                                    for(QueryDocumentSnapshot<Map<String,dynamic>> doc in documents){
                                      Map<String,dynamic> dataMap = doc.data();
                                      tempPortfolioData.add(ArtisanPortfolio(title: dataMap['title'], imageURL: dataMap['image url'], uploadDate: dataMap['time']));
                                    }
                                    portfolioData = tempPortfolioData;
                                    return SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Wrap(
                                            alignment: WrapAlignment.spaceBetween,
                                            runSpacing: 16,
                                            children: _buildPortfolioWidget(portfolioData),
                                          ),
                                        )
                                    );
                                  }
                                  else{
                                    //Add portfolio notice widget
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text('Add a portfolio.',style: TextStyle(fontSize: 18),),
                                        IconButton(onPressed: ()=>Navigator.pushNamed(context, addPortfolioScreen), icon: const Icon(Icons.add))
                                      ],
                                    );
                                  }
                              },
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showProfilePicture () {
    showDialog( builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(2),
      title: Container(
        decoration: const BoxDecoration(),
        width:  MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Image(
            image: NetworkImage('$profilePicture'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ),
        context: context
    );
  }


}


class PortfolioWidget extends StatelessWidget {
  const PortfolioWidget({super.key,required this.title,required this.imageURL, required this.uploadDate});
  final String title;
  final String imageURL;
  final String uploadDate;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, portfolioScreen,arguments: [title,imageURL,uploadDate]);
      },
      child: Container(
        height: 176,
        width: 176,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(
          imageURL,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const id = 'profile_screen';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserDetailsProvider.getUserType(),
        builder: (context,userType) {
          if(userType.hasData){
            if(userType.data! == UserType.artisan.name){
              log(userType.data!);
              return const ArtisanProfileScreen();
            }
            else if (userType.data! == UserType.client.name) {
              return const ClientProfileScreen();
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> with SingleTickerProviderStateMixin {

  bool isVerified = false;
  String name = 'blank';
  late String location;
  String email = 'blank';
  String? profilePicture;
  // List<ArtisanPortfolio> portfolioData = [];


  @override
  void initState() {
    var fName = Provider.of<UserDetailsProvider>(context,listen: false).firstName;
    var lName = Provider.of<UserDetailsProvider>(context,listen: false).lastName;
    email = Provider.of<UserDetailsProvider>(context,listen: false).email;
    location = Provider.of<UserDetailsProvider>(context,listen: false).location ?? 'Set location';
    name = '$fName $lName';
    var profilePic = Provider.of<UserDetailsProvider>(context,listen: false).profilePicture;

    if(profilePic == null){
      profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
    }else{
      profilePicture='$profilePic';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context,constraints){
            return ConstrainedBox(
              constraints: constraints,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: showProfilePicture,
                                  child: CircleAvatar(radius: 40,backgroundImage: NetworkImage('$profilePicture'),),

                                ),
                                const SizedBox(height: 8,),
                                Column(
                                  children: [
                                    isVerified ? const Icon(Icons.verified,color: Colors.green,) : const Icon(Icons.verified_outlined,color: Colors.red,),
                                    const SizedBox(width: 8,),
                                    isVerified ? const Text('Verified') : const Text('Unverified')
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(name,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18,),),
                                const SizedBox(height: 8,),
                                Text(email,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14,),),
                                const SizedBox(height: 8,),
                                Text(location,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14,),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0,),
                    ClientLocationDropDown(currentLocation: location),
                    const SizedBox(height: 16.0,),
                    FilledButton(onPressed: (){
                      if(location!='Set location') {
                        location = Provider.of<SignupProvider>(context,listen: false).signupPersonalData['location'] ?? 'Set location';
                        FirebaseDatabase.updateUserDetails(data: {
                          'location': location,
                        }, uid: Authentication.instance.currentUser!.uid).then((value) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, authHandlerScreen);
                        });
                      }
                    }, child: const Text('Update location')),
                    const SizedBox(height: 16.0,),
                    const Text('Verification Status',),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            isVerified ? const Icon(Icons.verified,color: Colors.green,) : const Icon(Icons.verified_outlined,color: Colors.red,),
                            const SizedBox(width: 8,),
                            isVerified ? const Text('Verified') : const Text('Unverified')
                          ],
                        ),
                        isVerified ? FilledButton(style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey[300])
                        ),onPressed: (){}, child: const Text('Verify account')) : FilledButton(onPressed: (){}, child: const Text('Verify account'))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showProfilePicture () {
    showDialog( builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(2),
      title: Container(
        decoration: const BoxDecoration(),
        width:  MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Image(
            image: NetworkImage('$profilePicture'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ),
        context: context
    );
  }


}



