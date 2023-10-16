import 'package:flutter/foundation.dart';

class Conclave {
  final String id;
  final String name;
  final String banner;
  final String displayPic;
  final List<String> conversers;
  final List<String> moderators;

  Conclave({
    required this.id,
    required this.name,
    required this.banner,
    required this.displayPic,
    required this.conversers,
    required this.moderators,
  });

  Conclave copyWith({
    String? id,
    String? name,
    String? banner,
    String? displayPic,
    List<String>? conversers,
    List<String>? moderators,
  }) {
    return Conclave(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      displayPic: displayPic ?? this.displayPic,
      conversers: conversers ?? this.conversers,
      moderators: moderators ?? this.moderators,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'banner': banner,
      'displayPic': displayPic,
      'conversers': conversers,
      'moderators': moderators,
    };
  }

  factory Conclave.fromMap(Map<String, dynamic> map) {
    return Conclave(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      banner: map['banner'] ?? '',
      displayPic: map['displayPic'] ?? '',
      conversers: List<String>.from(map['conversers']),
      moderators: List<String>.from(map['moderators']),
    );
  }

  @override
  String toString() {
    return 'Conclave(id: $id, name: $name, banner: $banner, displayPic: $displayPic, conversers: $conversers, moderators: $moderators)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conclave &&
        other.id == id &&
        other.name == name &&
        other.banner == banner &&
        other.displayPic == displayPic &&
        listEquals(other.conversers, conversers) &&
        listEquals(other.moderators, moderators);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        name.hashCode ^
        banner.hashCode ^
        displayPic.hashCode ^
        conversers.hashCode ^
        moderators.hashCode;
  }
}
