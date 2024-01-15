import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/Services/providers/user_details_provider.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ArtisanHomeScreen extends StatefulWidget {
  const ArtisanHomeScreen({super.key});


  @override
  State<ArtisanHomeScreen> createState() => _ArtisanHomeScreenState();
}

class _ArtisanHomeScreenState extends State<ArtisanHomeScreen> {

  String? profilePicture;

  @override
  void initState() {
    // var profilePic = Provider.of<UserDetailsProvider>(context,listen: false).profilePicture;
    // profilePicture='$profilePic';
    // print('$profilePicture');
    super.initState();
  }


  late Map<String,dynamic> map;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int navItem = 0;
  bool isPending = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserDetailsProvider.getAllData(),
        builder: (context,snapshot){
          if(snapshot.hasData){

            //provider store
            map = snapshot.data!;
            context.read<UserDetailsProvider>().initProperties(map);
            var profilePic = Provider.of<UserDetailsProvider>(context,listen: false).profilePicture;

            if(profilePic == null){
              profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
            }else{
              profilePicture='$profilePic';
            }


            return Scaffold(
              key: _key,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: GestureDetector(
                  onTap: ()=>_key.currentState?.openDrawer(),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.topRight,
                    children: [
                       CircleAvatar(radius: 24,backgroundImage: NetworkImage('$profilePicture') ),
                      Visibility(
                          visible: isPending,
                          child: Positioned(
                              right: 4,
                              child: Container(
                                height: 16,
                                width:16,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle),
                              )
                          )
                      ),
                    ],
                  ),
                )
              ),
              drawer: Drawer(
                width: 360,
                child: Column(
                  children: [
                    DrawerHeader(
                      padding: const EdgeInsets.only(left: 16,bottom: 16),
                      decoration: const BoxDecoration(
                          // color: Colors.grey[400]
                      ),
                      child: Align(alignment: Alignment.centerLeft,child: GestureDetector(onTap: ()=>_key.currentState?.closeDrawer(),child:  CircleAvatar(radius: 24,backgroundImage:NetworkImage('$profilePicture') ,)),),),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      onTap: ()=>Navigator.pushNamed(context, profileScreen),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      onTap: (){
                        Navigator.pushNamed(context, appSettingsScreen);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app_outlined),
                      title: const Text('Sign out'),
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          title: 'Sign out',
                          desc: 'Are you sure you want to sign out?',
                          btnCancelOnPress: (){

                            // Navigator.pop(context);
                          },
                          btnOkOnPress: (){
                            FirebaseAuth.instance.signOut();
                          },
                        ).show();
                      },
                    ),
                  ],
                ),
              ),
              body: const ArtisanHomeWidget(),
              bottomNavigationBar: NavigationBar(
                selectedIndex: navItem,
                onDestinationSelected: (selected){
                  setState(() {
                    navItem = selected;
                  });
                },
                destinations: [
                  NavigationDestination(icon: navItem==0 ? const Icon(Icons.home_filled) : const Icon(Icons.home_outlined), label: 'Home'),
                  NavigationDestination(icon: navItem==1 ? const Icon(Icons.checklist) : const Icon(Icons.checklist_outlined), label: 'Jobs'),
                  NavigationDestination(icon: navItem==2 ? const Icon(Icons.payment) : const Icon(Icons.payment_outlined) , label: 'Pay'),
                  NavigationDestination(icon: navItem==3 ? const Icon(Icons.notifications) : const Icon(Icons.notifications_outlined), label: 'Alerts'),
                ],),
            );
          }
          else{
            return Scaffold(
              key: _key,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: isPending ? GestureDetector(
                  onTap: ()=>_key.currentState?.openDrawer(),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.topRight,
                    children: [
                      const CircleAvatar(radius: 24,backgroundImage: null,),
                      Positioned(right: 4,child: Container(height: 16, width:16, decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),)),

                    ],
                  ),
                ) : GestureDetector(onTap: ()=>_key.currentState?.openDrawer(),child: const CircleAvatar(radius: 24,backgroundImage: null,)),
              ),
              drawer: Drawer(
                width: 360,
                child: Column(
                  children: [
                    DrawerHeader(
                      padding: const EdgeInsets.only(left: 16,bottom: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey[400]
                      ),
                      child: Align(alignment: Alignment.centerLeft,child: GestureDetector(onTap: ()=>_key.currentState?.closeDrawer(),child: const CircleAvatar(radius: 24,backgroundImage: null,)),),),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      onTap: (){},
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      onTap: (){},
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app_outlined),
                      title: const Text('Sign out'),
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          title: 'Sign out',
                          desc: 'Are you sure you want to sign out?',
                          btnCancelOnPress: (){

                            // Navigator.pop(context);
                          },
                          btnOkOnPress: (){
                            FirebaseAuth.instance.signOut();
                          },
                        ).show();
                      },
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Welcome, ',style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24
                      ),),
                      const SizedBox(height: 32,),
                      const Text('Current jobs',style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                      ),),
                      FutureBuilder(future: null, builder: (context,snapshot){
                        if(snapshot.hasData){
                          return const Placeholder();
                        }
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 80,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text('No active job requests yet',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18
                            ),),
                        );
                      }), // request widget
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 136,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 72,
                                  width: 72,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff83A6FF),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Icon(Icons.people_outline,color: Color(0xff00247F),),
                                ),
                                const SizedBox(height: 8,),
                                const Text('Refer a friend',style: TextStyle(fontSize: 16),),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 72,
                                  width: 72,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff83A6FF),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Icon(Icons.reviews_outlined,color: Color(0xff00247F),),
                                ),
                                const SizedBox(height: 8,),
                                const Text('Reviews',style: TextStyle(fontSize: 16),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        elevation: 4,
                        color: const Color(0xff477BFF),
                        child: Padding(
                          padding: const EdgeInsets.only(left:16.0,top: 16,bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text('Having difficulties getting jobs? ',style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),),
                                    const SizedBox(height: 8,),
                                    const Text('Here are 5 sure ways you can improve your reach and get more jobs.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      softWrap: true,
                                    ),
                                    const SizedBox(height: 24,),
                                    ElevatedButton(onPressed: (){}, child: const Text('Read'))

                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/picture.png',
                                scale: 1.1,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.bottomRight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Stack(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           const Text('5 ways to get more clients',style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 18,
                      //             color: Colors.white,
                      //           ),),
                      //           const SizedBox(height: 8,),
                      //           const Text('Having difficulties getting jobs? Here are 5 sure ways you can improve your reach and get more jobs.',
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               color: Colors.white,
                      //             ),),
                      //           const SizedBox(height: 16,),
                      //           ElevatedButton(onPressed: (){}, child: const Text('Read'))
                      //
                      //         ],
                      //       ),
                      //     ),
                      //     Positioned(
                      //       right: 0,
                      //       child: Image.asset(
                      //         'assets/images/picture.png',
                      //         scale: 0.7,
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: navItem,
                onDestinationSelected: (selected){
                  setState(() {
                    navItem = selected;
                  });
                },
                destinations: [
                  NavigationDestination(icon: navItem==0 ? const Icon(Icons.home_filled) : const Icon(Icons.home_outlined), label: 'Home'),
                  NavigationDestination(icon: navItem==1 ? const Icon(Icons.checklist) : const Icon(Icons.checklist_outlined), label: 'Jobs'),
                  NavigationDestination(icon: navItem==2 ? const Icon(Icons.payment) : const Icon(Icons.payment_outlined) , label: 'Pay'),
                  NavigationDestination(icon: navItem==3 ? const Icon(Icons.notifications) : const Icon(Icons.notifications_outlined), label: 'Alerts'),
                ],),
            ); //loading or blank widgets
          }
        }
    );
  }
}

class ArtisanHomeWidget extends StatelessWidget {
  const ArtisanHomeWidget({super.key});
  // final Map<String, dynamic>? map;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome, ${context.watch<UserDetailsProvider>().firstName}',style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24
            ),),
            const SizedBox(height: 32,),
            const Text('Current jobs',style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18
            ),),
            FutureBuilder(future: null, builder: (context,snapshot){
              if(snapshot.hasData){
                return const Placeholder();
              }
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    // color: const Color(0xfff2f2f2),
                    borderRadius: BorderRadius.circular(10)
                ),
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('No active job requests yet',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
              );
            }), // request widget
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // color: const Color(0xfff2f2f2),
                  borderRadius: BorderRadius.circular(10)
              ),
              height: 136,
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xff83A6FF),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.people_outline,color: Color(0xff00247F),),
                      ),
                      const SizedBox(height: 8,),
                      const Text('Refer a friend',style: TextStyle(fontSize: 16),),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xff83A6FF),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.reviews_outlined,color: Color(0xff00247F),),
                      ),
                      const SizedBox(height: 8,),
                      const Text('Reviews',style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 32),
              elevation: 4,
              color: const Color(0xff477BFF),
              child: Container(
                height: 240,
                padding: const EdgeInsets.only(left:16.0,top: 16,bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Having difficulties getting jobs? ',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),),
                          const SizedBox(height: 8,),
                          const Text('Here are 5 sure ways you can improve your reach and get more jobs.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                          const Spacer(),
                          ElevatedButton(onPressed: (){}, child: const Text('Read'))

                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/picture.png',
                      scale: 1.1,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                    ),
                  ],
                ),
              ),
            ),
            // Stack(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text('5 ways to get more clients',style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18,
            //             color: Colors.white,
            //           ),),
            //           const SizedBox(height: 8,),
            //           const Text('Having difficulties getting jobs? Here are 5 sure ways you can improve your reach and get more jobs.',
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.white,
            //             ),),
            //           const SizedBox(height: 16,),
            //           ElevatedButton(onPressed: (){}, child: const Text('Read'))
            //
            //         ],
            //       ),
            //     ),
            //     Positioned(
            //       right: 0,
            //       child: Image.asset(
            //         'assets/images/picture.png',
            //         scale: 0.7,
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}


