import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState>{
  MainCubit() : super(const MainState());
  
  changePage(int index){
    if(state.selectedIndex!=index){
      emit(state.copyWith(selectedIndex: index));
    }
  }

}