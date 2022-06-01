class Weather {
    Weather({
        this.lat,
        this.lon,
        this.timezone,
        // this.timezoneOffset,
        this.current,
        this.hourly,
        // this.daily,
    });

    final double? lat;
    final double? lon;
    final String? timezone;
    // final int? timezoneOffset;
    final Current? current;
    final List<Current>? hourly;
    // final List<Daily>? daily;

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        lat: json["lat"],
        lon: json["lon"],
        timezone: json["timezone"],
        // timezoneOffset: json["timezone_offset"],
        current: Current.fromJson(json["current"]),
        hourly: List<Current>.from(json["hourly"].map((x) => Current.fromJson(x))),
        // daily: List<Daily>.from(json["daily"].map((x) => Daily.fromJson(x))),
    );
}

class Current {
    Current({
        this.dt,
        this.sunrise,
        this.sunset,
        this.temp,
        this.pressure,
        this.humidity,
        this.dewPoint,
        this.uvi,
        this.clouds,
        this.visibility,
        this.windSpeed,
        this.windDeg,
        this.windGust,
        this.weather,
        // this.pop,
    });

    final int? dt;
    final int? sunrise;
    final int? sunset;
    final double? temp;
    final int? pressure;
    final int? humidity;
    final double? dewPoint;
    final double? uvi;
    final int? clouds;
    final int? visibility;
    final double? windSpeed;
    final int? windDeg;
    final double? windGust;
    final WeatherElement? weather;
    // final double? pop;

    factory Current.fromJson(Map<String, dynamic> json) => Current(
        dt: json["dt"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        temp: json["temp"],
        pressure: json["pressure"],
        humidity: json["humidity"],
        dewPoint: json["dew_point"].toDouble(),
        uvi: json["uvi"].toDouble(),
        clouds: json["clouds"],
        visibility: json["visibility"],
        windSpeed: json["wind_speed"],
        windDeg: json["wind_deg"],
        windGust: json["wind_gust"],
        weather: WeatherElement.fromJson(json["weather"][0]),
        // pop: json["pop"],
    );
}

class WeatherElement {
    WeatherElement({
        this.id,
        this.main,
        this.description,
        this.icon,
    });

    final int? id;
    final String? main;
    final String? description;
    final String? icon;

    factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
    );
}

enum Description { BROKEN_CLOUDS, SCATTERED_CLOUDS, OVERCAST_CLOUDS, LIGHT_RAIN, MODERATE_RAIN, CLEAR_SKY, FEW_CLOUDS }

final descriptionValues = EnumValues({
    "broken clouds": Description.BROKEN_CLOUDS,
    "clear sky": Description.CLEAR_SKY,
    "few clouds": Description.FEW_CLOUDS,
    "light rain": Description.LIGHT_RAIN,
    "moderate rain": Description.MODERATE_RAIN,
    "overcast clouds": Description.OVERCAST_CLOUDS,
    "scattered clouds": Description.SCATTERED_CLOUDS
});

enum Main { CLOUDS, RAIN, CLEAR }

final mainValues = EnumValues({
    "Clear": Main.CLEAR,
    "Clouds": Main.CLOUDS,
    "Rain": Main.RAIN
});

class Daily {
    Daily({
        this.dt,
        this.sunrise,
        this.sunset,
        this.moonrise,
        this.moonset,
        this.moonPhase,
        this.temp,
        this.feelsLike,
        this.pressure,
        this.humidity,
        this.dewPoint,
        this.windSpeed,
        this.windDeg,
        this.windGust,
        this.weather,
        this.clouds,
        this.pop,
        this.uvi,
        this.rain,
    });

    final int? dt;
    final int? sunrise;
    final int? sunset;
    final int? moonrise;
    final int? moonset;
    final double? moonPhase;
    final Temp? temp;
    final FeelsLike? feelsLike;
    final int? pressure;
    final int? humidity;
    final double? dewPoint;
    final double? windSpeed;
    final int? windDeg;
    final double? windGust;
    final List<WeatherElement>? weather;
    final int? clouds;
    final double? pop;
    final double? uvi;
    final double? rain;

    factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        dt: json["dt"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        moonrise: json["moonrise"],
        moonset: json["moonset"],
        moonPhase: json["moon_phase"],
        temp: Temp.fromJson(json["temp"]),
        feelsLike: FeelsLike.fromJson(json["feels_like"]),
        pressure: json["pressure"],
        humidity: json["humidity"],
        dewPoint: json["dew_point"],
        windSpeed: json["wind_speed"],
        windDeg: json["wind_deg"],
        windGust: json["wind_gust"],
        weather: List<WeatherElement>.from(json["weather"].map((x) => WeatherElement.fromJson(x))),
        clouds: json["clouds"],
        pop: json["pop"],
        uvi: json["uvi"],
        rain: json["rain"],
    );
}

class FeelsLike {
    FeelsLike({
        this.day,
        this.night,
        this.eve,
        this.morn,
    });

    final double? day;
    final double? night;
    final double? eve;
    final double? morn;

    factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
        day: json["day"],
        night: json["night"],
        eve: json["eve"],
        morn: json["morn"],
    );
}

class Temp {
    Temp({
        this.day,
        this.min,
        this.max,
        this.night,
        this.eve,
        this.morn,
    });

    final double? day;
    final double? min;
    final double? max;
    final double? night;
    final double? eve;
    final double? morn;

    factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        day: json["day"],
        min: json["min"],
        max: json["max"],
        night: json["night"],
        eve: json["eve"],
        morn: json["morn"],
    );
}

class EnumValues<T> {
    Map<String, T>? map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String>? get reverse {
        reverseMap ??= map!.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
