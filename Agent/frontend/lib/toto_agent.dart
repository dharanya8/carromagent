// class TotoAgent {
//
//   static final List<Map<String, dynamic>> db = [];
//
//   // STORE DATA (registration)
//   void registerPlayer(String name, String phone, String dob, String tournament) {
//     db.add({
//       "name": name,
//       "phone": phone,
//       "dob": dob,
//       "tournament": tournament
//     });
//   }
//
//   // SEARCH DATA
//   Map<String, dynamic>? findPlayer(String name, String phone) {
//     try {
//       return db.firstWhere((p) =>
//       p["name"] == name && p["phone"] == phone
//       );
//     } catch (e) {
//       return null;
//     }
//   }
// }