
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
   HomeCubit() : super(InitialHomeState());
    int counter = 0;
    static HomeCubit get(context) => BlocProvider.of(context);

    void incrementCounter(){
      counter++;
      emit(IncrementState());
    }

}