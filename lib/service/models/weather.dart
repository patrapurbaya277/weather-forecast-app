class Weather {
    Weather({
        this.lat,
        this.lon,
        this.timezone,
        this.current,
        this.hourly,
        this.daily,
    });

    final double? lat;
    final double? lon;
    final String? timezone;
    final Current? current;
    final List<Current>? hourly;
    final List<Daily>? daily;

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        lat: json["lat"],
        lon: json["lon"],
        timezone: json["timezone"],
        current: Current.fromJson(json["current"]),
        hourly: List<Current>.from(json["hourly"].map((x) => Current.fromJson(x))),
        daily: List<Daily>.from(json["daily"].map((x) => Daily.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "timezone": timezone,
        "current": current!.toJson(),
        "hourly": List.from(hourly!.map((x) => x.toJson())),
        "daily": List<dynamic>.from(daily!.map((x) => x.toJson())),
    };
}

class Current {
    Current({
        this.dt,
        this.temp,
        this.humidity,
        this.windSpeed,
        this.weather,
    });

    final int? dt;
    final double? temp;
    final int? humidity;
    final double? windSpeed;
    final WeatherElement? weather;

    factory Current.fromJson(Map<String, dynamic> json) => Current(
        dt: json["dt"],
        temp: json["temp"].toDouble(),
        humidity: json["humidity"],
        windSpeed: json["wind_speed"].toDouble(),
        weather: WeatherElement.fromJson(json["weather"] is List?json["weather"][0]:json["weather"]),
    );

    Map<String, dynamic> toJson() => {
        "dt": dt,
        "temp": temp,
        "humidity": humidity,
        "wind_speed": windSpeed,
        "weather": weather!.toJson(),
    };

}

class WeatherElement {
    WeatherElement({
        this.id,
        this.description,
        this.icon,
    });

    final int? id;
    final String? description;
    final String? icon;

    factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
        id: json["id"],
        description: json["description"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "icon": icon,
    };
}

class Daily {
    Daily({
        this.dt,
        this.temp,
        this.humidity,
        this.windSpeed,
        this.weather,
        this.rain,
    });

    final int? dt;
    final Temp? temp;
    final int? humidity;
    final double? windSpeed;
    final WeatherElement? weather;
    final double? rain;

    factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        dt: json["dt"],
        temp: Temp.fromJson(json["temp"]),
        humidity: json["humidity"],
        windSpeed: json["wind_speed"],
        weather: WeatherElement.fromJson(json["weather"] is List?json["weather"][0]:json["weather"]),
        rain: json["rain"],
    );

    Map<String, dynamic> toJson() => {
        "dt": dt,
        "temp": temp!.toJson(),
        "humidity": humidity,
        "wind_speed": windSpeed,
        "weather": weather!.toJson(),
        "rain": rain,
    };
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
        day: json["day"].toDouble(),
        min: json["min"],
        max: json["max"],
        night: json["night"],
        eve: json["eve"],
        morn: json["morn"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "min": min,
        "max": max,
        "night": night,
        "eve": eve,
        "morn": morn,
    };
}
