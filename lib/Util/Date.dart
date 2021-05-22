import 'package:intl/intl.dart';


String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';
  print(diff.inDays);

  if (diff.inDays == 0){
    time = DateFormat.Hm().format(date);
  } else if (diff.inDays > 0 && diff.inDays <= 7){
    time = diff.inDays.toString() + " Day ago";
  } else if (diff.inDays > 8){
    time = DateFormat.y().format(now);
    if (DateFormat.y().format(now) == DateFormat.y().format(date)){
      time = DateFormat.MMMd().format(date);
    } else {
      time = DateFormat.yMMMd().format(date);
    }
  }
  return time;
}