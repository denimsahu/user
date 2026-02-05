import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/GlobalVariables/Variables.dart';
import 'package:user/home/bloc/home_bloc.dart';
import 'package:user/search/view/SearchPage.dart';
import 'package:lottie/lottie.dart' as lottie;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late GoogleMapController googleMapController;
  late StreamSubscription<Position> userMarkerStream; 
  List<Marker> Markers = [];
  bool GeneratorOn =true;
  
   Stream<List<Marker>> startDriversPositionStream() async* {
    try{
        await for (QuerySnapshot<Map<String, dynamic>> snapshot
          in firebaseFirestore.collection("Drivers").snapshots()) {
            if(!GeneratorOn){throw{"Drivers Generator Stopped"};};
        try{for (QueryDocumentSnapshot document in snapshot.docs) {
          String markerid = document.get("MarkerId").toString();
          String latitide = document.get("latitude").toString();
          String langitude = document.get("langitude").toString();
          
            if((latitide=="0" && langitude=="0")||!document.get("IsOn")){
              try{
                Markers.removeWhere((element) => element.markerId==MarkerId(markerid));
              }
              catch(error){
                debugPrint(error.toString());
              }
            }
            else{
             try {
                int existingIndex = Markers.indexWhere((element) => element.markerId == MarkerId(markerid));
                if (existingIndex != -1) {
                  // Driver marker already exists, update its position
                  Markers[existingIndex] = Marker(
                    markerId: MarkerId(markerid),
                    icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0),), "assets/redbus-removebg-preview3.png"),
                    position: LatLng(double.parse(latitide), double.parse(langitude)),
                    infoWindow: InfoWindow(
                      title: markerid,
                    ),
                    onTap: () {
                      context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                      googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                    },
                  );
                } else {
                  // Driver marker doesn't exist, add it to the end of the list
                  Markers.add(
                    Marker(
                      markerId: MarkerId(markerid),
                      icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0),), "assets/redbus-removebg-preview3.png"),
                      position: LatLng(double.parse(latitide), double.parse(langitude)),
                      infoWindow: InfoWindow(
                        title: markerid,
                      ),
                      onTap: () {
                        context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                      },
                    ),
                  );
                }
              } catch (error) {
                debugPrint("Error while trying to add driver markers: ${error.toString()}");
              }
            }

        }}
        catch(e){
          debugPrint("Error while trying to start Drivers Stream ${e.toString()}");
        }
        yield Markers;
      }
    }
    catch(error){
      debugPrint("error ${error.toString()}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userMarkerStream.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(HomePageGetUserLocationPermissionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerEdgeDragWidth: 40.0,
      drawer: Drawer(
        elevation: 80.0,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(40.0), left: Radius.zero)),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
                height: MediaQuery.of(context).size.height*0.3,
                color: Colors.amber[300],
                child: lottie.Lottie.asset("assets/lightBlueBusDrawerAnimation.json",fit: BoxFit.contain)
                ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Favorite'),
              onTap: () {
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                            },
            ),
            Container(
                margin: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width*0.08)/2,MediaQuery.of(context).size.height*0.4,(MediaQuery.of(context).size.width*0.08)/2,0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 213, 79)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 0.0,vertical: 13.0), // Adjust the horizontal padding as needed
                      ),
                    ),
                    onPressed: () async {
                      await getStorage.erase();
                      GeneratorOn=false;
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, "/login");
                    },
                    child: Text("Logout",style: TextStyle(color: Colors.black),)),
              )
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(icon: Icon(Icons.menu,size: 30.0,color: Colors.black,),onPressed: (){Scaffold.of(context).openDrawer();},);
          }
        ),
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black),
          ),
        centerTitle: true,
        backgroundColor: Colors.amber[300],
        ),
      body: Stack(
        children: [
          MultiBlocListener(
            listeners: [
              BlocListener<HomeBloc,HomeState>(listener: (BuildContext context,state) async {
                if(state is HomePageLoadingState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.Message.toString())));
                }
                else if(state is HomePageGetUserLocationPermissionSuccessState){
                  context.read<HomeBloc>().add(HomePageStartUserLocationStreamEvent());
                }
                else if(state is HomePageStartUserLocationStreamState){
                  try{
                    if(userMarkerStream==null){
                      debugPrint("Should'nt be printing in any case accoording to my hit and learn method");
                    }
                  }
                  catch(error){
                    if(error.toString().contains("LateInitializationError: Field 'userMarkerStream' has not been initialized.")){
                      userMarkerStream = await Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.best)).listen((event) async {
                        try {
                          int userIndex = Markers.indexWhere((element) => element.markerId == MarkerId("User"));
                          if (userIndex != -1) {
                            Markers[userIndex] = Marker(
                              markerId: MarkerId("User"), 
                              position: LatLng(event.latitude, event.longitude), 
                              icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(10.0),), "assets/mylocation.png"),
                              );
                          } else {
                            Markers.add(Marker(
                              markerId: MarkerId("User"),
                              position: LatLng(event.latitude, event.longitude),
                              icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(10.0),), "assets/mylocation.png"),
                              ));
                            googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(event.latitude, event.longitude), 16.0));
                          }
                        } 
                        catch (error) {
                          debugPrint("Error while trying to add user markers: ${error.toString()}");
                        }
                        },
                        onError: (Error){
                          context.read<HomeBloc>().add(HomePageErrorEvent(errorMessage: "Gps is Disabled, Please Enable it to Get Your Live Location."));

                        });
                    }
                    else{
                      debugPrint("Stream already running....");
                      debugPrint(error.toString());
                    }
                  }
                }
              }),
            ],
            child: StreamBuilder<Iterable<Marker>>(
              stream: startDriversPositionStream(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return BlocConsumer<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if(state is HomePageErrorState){
                        ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.ErrorMessage)));
                      }
                      else if (state is HomePageAddPolylinState){
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom((state.cameraUpdateLatLang), 16.0));
                      }
                    },
                    builder: (context, state) {
                      return GoogleMap(
                        mapType: MapType.normal,
                        onMapCreated: (controller) {
                          googleMapController=controller;
                        },
                        initialCameraPosition: CameraPosition(target: LatLng(24.5469221, 73.7025429)),
                        zoomControlsEnabled: false,
                        markers: Set<Marker>.of(snapshot.data!),
                        polylines: Set.from([Polyline(polylineId: PolylineId("1"),points: state is HomePageAddPolylinState?state.route:[])]),
                      );
                    },
                  );
                }
                else{
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(24.5469221, 73.7025429)),
                    zoomControlsEnabled: false,
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: 
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 15),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                child: Container(
                  // margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(30)),
                  height: 55,
                  child: TextField(
                    // controller: EndPoint,
                    onTap: () {
                      Navigator.push(context , MaterialPageRoute(builder: (BuildContext context)=> SearchPage()));
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Search Bus',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width*0.2,
            height:  MediaQuery.of(context).size.height*0.08,
              bottom: 30,
              right: 10,
               child: Opacity(
                opacity: 0.6,
                 child: FloatingActionButton(
                    elevation: 20.0,
                    onPressed: (){
                      int markerid=Markers.indexWhere((element) => element.markerId==MarkerId("User"));
                      if(markerid==-1){
                        context.read<HomeBloc>().add(HomePageGetUserLocationPermissionEvent());
                      }
                      else{
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom(Markers[markerid].position, 16));
                      }
                    },
                    child: Icon(Icons.gps_fixed,size: 30.0,color: Colors.white,),
                    backgroundColor: Colors.black,
                  ),
               ),
             ),
      ])
    );
  }
}
