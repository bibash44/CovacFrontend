class VaccinationCentre {
  String? _id;
  String? name;
  String? postCode;
  String? streetAddress;
  String? description;
  String? latitude;
  String? longitude;

  VaccinationCentre(
    this._id,
    this.name,
    this.postCode,
    this.streetAddress,
    this.description,
    this.latitude,
    this.longitude,
  );

  get id => this._id;

  set id(value) => this._id = value;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getPostCode => this.postCode;

  set setPostCode(postCode) => this.postCode = postCode;

  get getStreetAddress => this.streetAddress;

  set setStreetAddress(streetAddress) => this.streetAddress = streetAddress;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  get getLatitude => this.latitude;

  set setLatitude(latitude) => this.latitude = latitude;

  get getLongitude => this.longitude;

  set setLongitude(longitude) => this.longitude = longitude;
}
