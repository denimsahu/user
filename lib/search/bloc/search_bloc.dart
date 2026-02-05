import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user/GlobalVariables/Variables.dart';
import 'package:user/search/Models/BusModel.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchBusSubmitEvent>((event, emit) async {
      emit(SearchBusLoadingState());
      List<String> Buses=[];
      if(event.EndPoint.isEmpty || event.StartPoint.isEmpty){
        emit(SearchBusErrorState(ErrorMessage: "Please Fill Both Stops Name"));
      }
      else{
        await firebaseFirestore.collection("Stops").get().then((value) {
              value.docs.forEach((element) {
                  try {
                    bool start = false;
                    bool stop = false;
                    int startKey = 0;
                    int stopKey = 0;
                    element.data().forEach((key, value) {
                      if (value.toString().toLowerCase() == event.StartPoint.toLowerCase()) {
                        startKey=int.parse(key);
                        start = true;
                      }
                      if (value.toString().toLowerCase() == event.EndPoint.toLowerCase()) {
                        stopKey = int.parse(key);
                        stop = true;
                      }
                    });

                    if (start && stop) {
                      if(element.get("IsOn")&&element.get("IsGoingToTheEnd")&&startKey<stopKey){
                        print("This bus will work ${element.id}");
                        Buses.add(element.id);
                      }
                      else if(element.get("IsOn")&&!element.get("IsGoingToTheEnd")&&startKey>stopKey){
                        print("This bus will work ${element.id}");
                        Buses.add(element.id);
                      }
                    }
                  } 
                  catch (error) {
                    emit(SearchBusErrorState(ErrorMessage:error.toString()));
                    print(error.toString());
                  }
                });
            });
        if(Buses.isEmpty){
          print("No Bus To Show");
          emit(SearchBusErrorState());
        }
        else{
          try{
            List<BusModel> BusModels=[];
            await firebaseFirestore.collection("Drivers").get().then((value){
              value.docs.forEach((element) {
                if(Buses.contains(element.id.toString())){
                  BusModels.add(BusModel(element: element));
                }
              });
            });
            emit(SearchBusResultState(BusModels: BusModels));
          }
          catch(error){
            print(error.toString());
            emit(SearchBusErrorState(ErrorMessage:error.toString()));
          }
        }
      }
    });
  }
}
