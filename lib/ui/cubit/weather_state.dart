part of 'weather_cubit.dart';

class WeatherState extends Equatable {
  final Weather? weatherData;
  final bool loading;
  final String? errorMessage;
  final DateTime? updatedAt;

  const WeatherState({
    this.weatherData,
    this.loading=true,
    this.errorMessage,
    this.updatedAt,
  });

  WeatherState copyWith({
    Weather? weatherData,
    bool? loading,
    String? errorMessage,
    DateTime? updatedAt,
  }) =>
      WeatherState(
        weatherData: weatherData ?? this.weatherData,
        loading: loading??false,
        errorMessage: errorMessage,
        updatedAt: updatedAt??this.updatedAt,
      );

  @override
  List<Object?> get props => [
    loading,
    weatherData,
    errorMessage,
    updatedAt,
  ];
}
