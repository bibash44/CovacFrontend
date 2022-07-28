class appointment {
  String? _id;
  String? vcentreId;
  String? appointmentDate;

  get id => this._id;

  set id(value) => this._id = value;

  get getVcentreId => this.vcentreId;

  set setVcentreId(vcentreId) => this.vcentreId = vcentreId;

  get getAppointmentDate => this.appointmentDate;

  set setAppointmentDate(appointmentDate) =>
      this.appointmentDate = appointmentDate;
}
