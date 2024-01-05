import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  
  bool isVerified = false;
  String name = 'blank blank';
  String occupation = 'blank';
  String location = 'blank';
  String priceRate = '0000';
  double rating = 4;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(radius: 40,backgroundImage: null,),
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            isVerified ? const Icon(Icons.verified,color: Colors.green,) : const Icon(Icons.verified_outlined,color: Colors.red,),
                            const SizedBox(width: 8,),
                            isVerified ? const Text('Verified') : const Text('Unverified')
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("₦$priceRate.00",style: const TextStyle(letterSpacing: 0.5,fontWeight: FontWeight.w600,fontSize: 18),),
                        const SizedBox(height: 48,),
                        ElevatedButton(onPressed: (){}, child: const Text('Edit')),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              const TabBar(
                  tabs: [
                    Tab(text: 'Recent jobs',),
                    Tab(text: 'Portfolio',),
              ]),
              Expanded(
                child: TabBarView(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 16,
                          children: [
                            Container(
                              height: 176,
                              width: 176,
                              decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(16),
                                image: null
                              ),
                            ),
                            Container(
                              height: 176,
                              width: 176,
                              decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(16),
                                image: null
                              ),
                            ),
                            Container(
                              height: 176,
                              width: 176,
                              decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(16),
                                image: null
                              ),
                            ),
                          ],
                        ),
                      ),


                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}