import 'package:ticket_app/data/model/bag.dart';
import 'package:ticket_app/data/model/day.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/travel.dart';

class HomeViewModel {
  final List<Day> days;
  final List<Bag> bags;
  final List<StateModel> states;
  final List<Travel> travels;
  HomeViewModel(this.days, this.bags, this.states, this.travels);
}
