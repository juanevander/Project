// class Temuan {
//   String namaTemuan;
//   String penanggungJawab;
//   List<String> dokumentasiTemuan;

//   Temuan(
//       {required this.namaTemuan,
//       required this.penanggungJawab,
//       this.dokumentasiTemuan = const []});

//   void tambahDokumentasi(String fileDokumentasi) {
//     dokumentasiTemuan.add(fileDokumentasi);
//   }

//   void tampilkanInformasiTemuan() {
//     print('Nama Temuan: $namaTemuan');
//     print('Penanggung Jawab: $penanggungJawab');
//     if (dokumentasiTemuan.isNotEmpty) {
//       print('Dokumentasi Temuan:');
//       for (var i = 0; i < dokumentasiTemuan.length; i++) {
//         print('  ${i + 1}. ${dokumentasiTemuan[i]}');
//       }
//     } else {
//       print('Belum ada dokumentasi temuan.');
//     }
//   }
// }

// void main() {
//   // Contoh penggunaan class Temuan
//   var temuanBaru =
//       Temuan(namaTemuan: 'Kerusakan Jalan', penanggungJawab: 'Budi');

//   // Menambahkan dokumentasi temuan berupa file gambar
//   temuanBaru.tambahDokumentasi('foto1.jpg');
//   temuanBaru.tambahDokumentasi('foto2.jpg');
//   temuanBaru.tambahDokumentasi('foto3.jpg');

//   // Menampilkan informasi temuan
//   temuanBaru.tampilkanInformasiTemuan();
// }
