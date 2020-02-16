class AddressModel {
  final String locality;
  final String postalCode;
  final String country;
  final String subThoroughfare;
  final String thoroughfare;
  final String subLocality;
  final String subAdministrativeArea;
  final String name;
  
  AddressModel(
      {this.locality,
      this.postalCode,
      this.country,
      this.subThoroughfare,
      this.thoroughfare,
      this.subLocality,
      this.subAdministrativeArea,
      this.name});
}
