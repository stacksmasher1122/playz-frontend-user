class VenueModel {
  final String venueName;
  final String? venueImage;
  final String status;
  final int duration;
  final String format;
  final String weatherTemp;
  final String weatherCondition;
  final String? weatherIcon;
  final String referee;
  final String recordingSystem;

  const VenueModel({
    required this.venueName,
    this.venueImage,
    required this.status,
    required this.duration,
    required this.format,
    required this.weatherTemp,
    required this.weatherCondition,
    this.weatherIcon,
    required this.referee,
    required this.recordingSystem,
  });

  VenueModel copyWith({
    String? venueName,
    String? venueImage,
    String? status,
    int? duration,
    String? format,
    String? weatherTemp,
    String? weatherCondition,
    String? weatherIcon,
    String? referee,
    String? recordingSystem,
  }) {
    return VenueModel(
      venueName: venueName ?? this.venueName,
      venueImage: venueImage ?? this.venueImage,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      format: format ?? this.format,
      weatherTemp: weatherTemp ?? this.weatherTemp,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherIcon: weatherIcon ?? this.weatherIcon,
      referee: referee ?? this.referee,
      recordingSystem: recordingSystem ?? this.recordingSystem,
    );
  }
}
