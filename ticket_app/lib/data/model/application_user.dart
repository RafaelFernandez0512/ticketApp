class ApplicationUser {
  final String? oid;
  final bool? changePasswordOnFirstLogon;
  final String? userName;
  final bool? isActive;
  final DateTime? lockoutEnd;
  final int? accessFailedCount;
  final bool? puedeScanear;

  ApplicationUser({
    this.oid,
    this.changePasswordOnFirstLogon,
    this.userName,
    this.isActive,
    this.lockoutEnd,
    this.accessFailedCount,
    this.puedeScanear,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      oid: json['Oid'] as String?,
      changePasswordOnFirstLogon: json['ChangePasswordOnFirstLogon'] as bool?,
      userName: json['UserName'] as String?,
      isActive: json['IsActive'] as bool?,
      lockoutEnd: json['LockoutEnd'] != null
          ? DateTime.parse(json['LockoutEnd'])
          : null,
      accessFailedCount: json['AccessFailedCount'] as int?,
      puedeScanear: json['PuedeScanear'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Oid': oid,
      'ChangePasswordOnFirstLogon': changePasswordOnFirstLogon,
      'UserName': userName,
      'IsActive': isActive,
      'LockoutEnd': lockoutEnd?.toIso8601String(),
      'AccessFailedCount': accessFailedCount,
      'PuedeScanear': puedeScanear,
    };
  }
}