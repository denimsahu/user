import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:user/GlobalWidgets/CustomBigElevatedButton.dart';
import 'package:user/home/bloc/home_bloc.dart';
import 'package:user/search/bloc/search_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController StartPoint = TextEditingController();
  TextEditingController EndPoint = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Search Buses",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber[300],
        ),
        body: Stack(children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            // margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(30)),
                            height: 55,
                            child: TextField(
                              controller: StartPoint,
                              decoration: InputDecoration(
                                hintText: 'Start Point',
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            backgroundColor: Colors.amber.shade400,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5.0),
                          ),
                          onPressed: () {
                            String startPoint = StartPoint.text;
                            StartPoint.text = EndPoint.text;
                            EndPoint.text = startPoint;
                          },
                          child: ClipOval(
                            child: Image.asset(
                              "assets/UpDownArrow.png",
                              scale: 3.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                              controller: EndPoint,
                              decoration: InputDecoration(
                                hintText: 'End Point',
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.08),
                  child: Divider(
                    color: Colors.grey.shade500,
                    thickness: 2.0,
                  ),
                ),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return Text(state is SearchInitial?"Search For Buses": (state is SearchBusErrorState && (state.ErrorMessage!=null && state.ErrorMessage!.contains("Please Fill Both Stops Name")))?"Search For Buses": state is SearchBusErrorState? "No Available Buses": state is SearchBusLoadingState? "Loading Buses...":"Available Buses",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w600),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: BlocConsumer<SearchBloc, SearchState>(
                    listener: (context, state) {
                      if (state is SearchBusErrorState &&
                          state.ErrorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(state.ErrorMessage.toString())));
                      }
                    },
                    builder: (context, state) {
                      if (state is SearchBusLoadingState) {
                        return lottie.LottieBuilder.asset(
                          "assets/loadingBusesOrangeBusAnimation.json",
                        );
                      }
                      else if (state is SearchBusErrorState && (state.ErrorMessage!=null && state.ErrorMessage!.contains("Please Fill Both Stops Name"))){
                        return Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                            lottie.LottieBuilder.asset(
                              "assets/signupScreenAnimation.json",
                            ),
                          ],
                        );
                      }
                      else if (state is SearchBusResultState) {
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01),
                            itemCount: state.BusModels.length,
                            itemBuilder: (context, int index) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                      child: Card(
                                        elevation: 10.0,
                                        shape: RoundedRectangleBorder(
                                            //<-- SEE HERE
                                            side: BorderSide(
                                                width: 2,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: ListTile(
                                          onTap: () {
                                            context.read<HomeBloc>().add(
                                                HomePageAddPolylineEvent(
                                                    DriverUsername: state
                                                        .BusModels[index]
                                                        .BusNumber
                                                        .toString()));
                                            Navigator.pop(context);
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          leading: Container(
                                            padding:
                                                EdgeInsets.only(right: 12.0),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(
                                                        width: 2.0,
                                                        color: Colors
                                                            .grey.shade400))),
                                            child: CircleAvatar(
                                              child: lottie.LottieBuilder.asset(
                                                  "assets/busIconAnimation.json"),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          title: Text(
                                            'Bus Number : ${state.BusModels[index].BusNumber}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                              'Driver : ${state.BusModels[index].DriverFirstName} ${state.BusModels[index].DriverLastName}'),
                                          trailing: Icon(Icons.more_vert),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      thickness: 5,
                                      indent:
                                          MediaQuery.of(context).size.width *
                                              0.015,
                                      endIndent:
                                          MediaQuery.of(context).size.width *
                                              0.015,
                                    ),
                                  ],
                                ),
                              );
                            });
                      } 
                      else if (state is SearchBusErrorState) {
                        return Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                            lottie.LottieBuilder.asset(
                                "assets/busNotFoundAnimation.json"),
                          ],
                        );
                      } 
                     
                      else {
                        return Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                            lottie.LottieBuilder.asset(
                                "assets/signupScreenAnimation.json"),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return CustomBigElevatedButton(
                  color: state is SearchBusLoadingState? Colors.amber.shade100: Colors.amber.shade300,
                  text: state is SearchBusLoadingState ? null : "Search",
                  child: state is SearchBusLoadingState? lottie.LottieBuilder.asset("assets/loadingDots.json"): null,
                  context: context,
                  onPressed: () {
                    if (state is SearchInitial &&(StartPoint.text.isEmpty || EndPoint.text.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Fill Both Stops Name")));
                    } else {
                      context.read<SearchBloc>().add(SearchBusSubmitEvent(
                          StartPoint: StartPoint.value.text,
                          EndPoint: EndPoint.value.text));
                    }
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
