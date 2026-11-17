# Planner Tugas Kuliah — Tugas Rutin 7

**NIM:** 4243250005  
**Nama:** isi nama lengkap

Aplikasi Flutter untuk mencatat tugas kuliah, mata kuliah, dan batas pengumpulan. Daftar, form, dan statistik memakai state tugas bersama; filter daftar tetap menjadi state lokal halaman.

## Fitur

- Daftar tugas dengan filter **Semua**, **Aktif**, dan **Selesai**.
- Form tambah tugas dengan validasi judul/mata kuliah serta pemilih tanggal dan waktu.
- Tandai tugas selesai atau hapus tugas.
- Statistik total, aktif, selesai, dan persentase yang diperbarui otomatis.
- Navigasi tiga halaman menggunakan `go_router`, dengan `NavigationBar` di ponsel dan `NavigationRail` di layar lebar.
- Contoh tiga tugas disediakan agar daftar dan statistik terlihat saat aplikasi pertama kali dibuka.

## Tangkapan layar

Simpan tangkapan layar dari ketiga halaman berikut di folder `screenshots/`, lalu tambahkan gambar ke bagian ini:

- `daftar-tugas.png` — halaman daftar dan filter.
- `form-tugas.png` — halaman tambah tugas.
- `statistik.png` — halaman statistik.

## Diagram state dan lifecycle

```text
ChangeNotifierProvider<TaskProvider>
├── Daftar tugas
│   ├── Consumer: daftar dan ringkasan tugas bersama
│   └── setState: filter Semua/Aktif/Selesai (state lokal)
├── Tambah tugas
│   ├── initState: buat TextEditingController
│   ├── Simpan: validasi → TaskProvider.addTask → kembali ke daftar
│   └── dispose: lepas kedua controller
└── Statistik
    └── Consumer: hitung ulang total, selesai, dan persentase
```

### Keputusan state management

Provider dipilih karena data tugas perlu dibaca dan diubah dari beberapa halaman, sementara aturan state-nya sederhana. `TaskProvider` adalah satu pemilik daftar `CollegeTask`; jumlah total, aktif, selesai, dan persentase dihitung dari daftar itu agar tidak ada salinan statistik yang bisa berbeda dari data sumber. Operasi tambah, ubah status selesai, dan hapus memanggil `notifyListeners`. Halaman daftar memakai `Consumer`, badge navigasi memakai `context.select`, dan halaman statistik memakai `Consumer` agar bagian yang bergantung pada data dibangun ulang setelah perubahan. Filter Semua/Aktif/Selesai sengaja menjadi ephemeral state milik `TaskListPage`: `setState` mengubah pilihan filter tanpa mengubah isi state bersama. `TaskFormPage` membuat controller judul dan mata kuliah di `initState`, mempertahankannya selama halaman hidup, lalu memanggil `dispose` untuk melepas resource ketika halaman ditutup. Setelah validasi, form mengirim nilai yang sudah dipangkas ke Provider; `go_router` mengarahkan kembali ke daftar. Saya memilih Provider dibanding Cubit karena model state sederhana, tidak memerlukan event terpisah, dan integrasinya dengan `ChangeNotifier` memudahkan demonstrasi alur state untuk aplikasi tiga layar ini. Model tugas tetap immutable, sementara seluruh perubahan melewati satu pemilik state sehingga mudah diuji tanpa UI.

## Menjalankan aplikasi

```powershell
flutter pub get
flutter run
```

## Pengujian

```powershell
flutter analyze
flutter test
```

Tes mencakup perubahan state/statistik Provider, penolakan input tidak valid, filter lokal, pembaruan statistik lintas halaman, dan alur form tambah tugas.

## Struktur utama

```text
lib/
  data/         Tugas contoh
  models/       Model CollegeTask
  router/       Rute go_router
  screens/      Shell, daftar, form, dan statistik
  state/        TaskProvider
  widgets/      Kartu tugas
test/
  task_provider_test.dart
  widget_test.dart
```

## Pernyataan penggunaan AI

AI digunakan sebagai bantuan untuk menyusun struktur aplikasi, implementasi state management, contoh data, dan pengujian. Kode ditinjau serta divalidasi sebelum dikumpulkan.
