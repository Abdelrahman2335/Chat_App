
class ErrorMap {


  static String mapErrorToMessage(Object error) {
    final errorStr = error.toString();
    if (errorStr.contains("Room already exist")) return "Room already exists";
    if (errorStr.contains("Email not exist")) return "Email doesn't exist";
    if (errorStr.contains("You can't chat with yourself")) return "You can't chat with yourself";
    return "Something went wrong";
  }

  static String mapAuthErrorToMessage(Object error){
    final errorStr = error.toString();

    return errorStr;
  }

}
