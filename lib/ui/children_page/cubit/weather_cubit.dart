import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_forecast_app/repository/weather_repository.dart';
import 'package:weather_forecast_app/service/local/pref.dart';
import 'package:weather_forecast_app/service/models/app_exception.dart';
import 'package:weather_forecast_app/service/models/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState>{
  WeatherCubit() : super(const WeatherState());
  WeatherRepository repository = WeatherRepository();

  fetchData(double lon, double lat)async{
    var data = await repository.fetchData(lat, lon);
    if(data is Weather){
      emit(state.copyWith(weatherData: data, updatedAt: DateTime.now()));
    }else{
      if(data is NoConnectionException){
        if(Pref.recentWeather!=null){
          Pref.load();
          emit(state.copyWith(weatherData: Pref.recentWeather, updatedAt: Pref.recentDate));
        }
      }
      emit(state.copyWith(errorMessage: data.prefix));
    }
  }

  refreshData(double lon, double lat)async{
    emit(state.copyWith(loading: true));
    fetchData(lon, lat);
  }

}