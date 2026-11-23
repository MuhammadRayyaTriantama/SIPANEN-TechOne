
# Skema Relasional SIPANEN

## 1. Daftar Entitas dan Skema Relasional

### 1. KABUPATEN

`kabupaten(id_kabupaten, nama_kabupaten)`

PK: id_kabupaten
UK: nama_kabupaten
FK: tidak ada

### 2. KOMODITAS

`komoditas(id_komoditas, nama_komoditas, satuan)`

PK: id_komoditas
UK: nama_komoditas
FK: tidak ada

### 3. JENIS_SENSOR

`jenis_sensor(id_jenis_sensor, nama_jenis_sensor, satuan)`

PK: id_jenis_sensor
UK: nama_jenis_sensor
FK: tidak ada

### 4. PENGGUNA

`pengguna(id_pengguna, nama, email, password_hash, peran, id_kabupaten)`

PK: id_pengguna
UK: email
FK:
- id_kabupaten → kabupaten(id_kabupaten)

Catatan: id_kabupaten boleh NULL.

### 5. LAHAN

`lahan(id_lahan, nama_lahan, luas_hektar, latitude, longitude, id_kabupaten, id_pengguna)`

PK: id_lahan
FK:
- id_kabupaten → kabupaten(id_kabupaten)
- id_pengguna → pengguna(id_pengguna)

### 6. TITIK_SENSOR

`titik_sensor(id_titik_sensor, nama_titik, latitude, longitude, id_lahan)`

PK: id_titik_sensor
FK:
- id_lahan → lahan(id_lahan)

### 7. SENSOR

`sensor(id_sensor, kode_sensor, tanggal_pasang, status, id_titik_sensor, id_jenis_sensor)`

PK: id_sensor
UK: kode_sensor
FK:
- id_titik_sensor → titik_sensor(id_titik_sensor)
- id_jenis_sensor → jenis_sensor(id_jenis_sensor)

### 8. PEMBACAAN_SENSOR

`pembacaan_sensor(id_pembacaan, waktu_baca, nilai_angka, nilai_teks, id_sensor)`

PK: id_pembacaan
FK:
- id_sensor → sensor(id_sensor)

Catatan: nilai_angka dipakai untuk hasil pengukuran numerik, sedangkan nilai_teks untuk hasil berbentuk teks seperti kondisi cuaca. Salah satu nilai harus diisi.

### 9. PANEN

`panen(id_panen, tanggal_panen, jumlah_kg, id_lahan, id_komoditas)`

PK: id_panen
FK:
- id_lahan → lahan(id_lahan)
- id_komoditas → komoditas(id_komoditas)

### 10. HARGA_KOMODITAS

`harga_komoditas(id_harga, tanggal, harga_per_kg, id_komoditas, id_kabupaten)`

PK: id_harga
FK:
- id_komoditas → komoditas(id_komoditas)
- id_kabupaten → kabupaten(id_kabupaten)

### 11. ESTIMASI_HARGA

`estimasi_harga(id_estimasi, tanggal_estimasi, harga_estimasi, arah_perubahan, id_komoditas, id_kabupaten)`

PK: id_estimasi
FK:
- id_komoditas → komoditas(id_komoditas)
- id_kabupaten → kabupaten(id_kabupaten)

### 12. PREDIKSI_PANEN

`prediksi_panen(id_prediksi, tanggal_prediksi, estimasi_hasil_kg, tingkat_risiko, id_lahan, id_komoditas)`

PK: id_prediksi
FK:
- id_lahan → lahan(id_lahan)
- id_komoditas → komoditas(id_komoditas)

### 13. PERINGATAN_DINI

`peringatan_dini(id_peringatan, waktu_peringatan, pesan, id_prediksi)`

PK: id_peringatan
FK:
- id_prediksi → prediksi_panen(id_prediksi)

---

## 2. Pemetaan Relasi ERD

| No. | Relasi | Aturan | Hasil Pemetaan |
|---|---|---|---|
| 1 | KABUPATEN memiliki PENGGUNA | 4 | FK id_kabupaten di PENGGUNA |
| 2 | KABUPATEN memiliki LAHAN | 4 | FK id_kabupaten di LAHAN |
| 3 | PENGGUNA mengelola LAHAN | 4 | FK id_pengguna di LAHAN |
| 4 | LAHAN memiliki TITIK_SENSOR | 4 | FK id_lahan di TITIK_SENSOR |
| 5 | TITIK_SENSOR memiliki SENSOR | 4 | FK id_titik_sensor di SENSOR |
| 6 | JENIS_SENSOR digunakan SENSOR | 4 | FK id_jenis_sensor di SENSOR |
| 7 | SENSOR mengirim PEMBACAAN_SENSOR | 4 | FK id_sensor di PEMBACAAN_SENSOR |
| 8 | LAHAN dan KOMODITAS | 5 | Menggunakan PANEN sebagai tabel penghubung |
| 9 | KABUPATEN mencatat HARGA_KOMODITAS | 4 | FK id_kabupaten di HARGA_KOMODITAS |
| 10 | KOMODITAS memiliki HARGA_KOMODITAS | 4 | FK id_komoditas di HARGA_KOMODITAS |
| 11 | KABUPATEN memiliki ESTIMASI_HARGA | 4 | FK id_kabupaten di ESTIMASI_HARGA |
| 12 | KOMODITAS memiliki ESTIMASI_HARGA | 4 | FK id_komoditas di ESTIMASI_HARGA |
| 13 | LAHAN memiliki PREDIKSI_PANEN | 4 | FK id_lahan di PREDIKSI_PANEN |
| 14 | KOMODITAS diprediksi dalam PREDIKSI_PANEN | 4 | FK id_komoditas di PREDIKSI_PANEN |
| 15 | PREDIKSI_PANEN memicu PERINGATAN_DINI | 4 | FK id_prediksi di PERINGATAN_DINI |

### Penerapan Aturan 5

Relasi M:N antara LAHAN dan KOMODITAS menggunakan PANEN sebagai tabel penghubung.

PANEN menyimpan id_panen sebagai PK, id_lahan dan id_komoditas sebagai FK, serta tanggal_panen dan jumlah_kg sebagai atribut relasi.

### Ringkasan Aturan 1–7

| Aturan | Penerapan |
|---|---|
| 1. Entitas kuat | Diterapkan pada seluruh entitas |
| 2. Entitas lemah | Tidak digunakan |
| 3. Relasi 1:1 | Tidak digunakan |
| 4. Relasi 1:N | Digunakan pada relasi antarentitas |
| 5. Relasi M:N | LAHAN dan KOMODITAS melalui PANEN |
| 6. Atribut multivalued | Tidak ada |
| 7. Relasi n-ary | Tidak ada |

---

## 3. Normalisasi

### 1NF

Setiap kolom menyimpan satu nilai. Tidak ada kolom yang berisi daftar nilai sekaligus dan setiap tabel memiliki primary key.

### 2NF

Seluruh tabel menggunakan primary key tunggal sehingga tidak terdapat ketergantungan parsial terhadap primary key gabungan.

### 3NF

Atribut disimpan sesuai entitasnya masing-masing. Tidak terdapat ketergantungan transitif yang tersisa berdasarkan struktur dan dependensi yang digunakan dalam skema ini.

---

## 4. Urutan Pembuatan Tabel

| Urutan | Nama Tabel | Tabel yang Ditunjuk |
|---|---|---|
| 1 | kabupaten | Tidak ada |
| 2 | komoditas | Tidak ada |
| 3 | jenis_sensor | Tidak ada |
| 4 | pengguna | kabupaten |
| 5 | lahan | kabupaten, pengguna |
| 6 | titik_sensor | lahan |
| 7 | sensor | titik_sensor, jenis_sensor |
| 8 | pembacaan_sensor | sensor |
| 9 | panen | lahan, komoditas |
| 10 | harga_komoditas | kabupaten, komoditas |
| 11 | estimasi_harga | kabupaten, komoditas |
| 12 | prediksi_panen | lahan, komoditas |
| 13 | peringatan_dini | prediksi_panen |

---

## 5. Keputusan Perancangan

Entitas TITIK_SENSOR, SENSOR, JENIS_SENSOR, dan PEMBACAAN_SENSOR dipisahkan agar setiap titik pemantauan dapat memiliki perangkat sensor, jenis pengukuran, serta riwayat pembacaan yang tersusun dengan lebih jelas.

TITIK_SENSOR menyimpan lokasi pemasangan pada lahan. SENSOR menyimpan identitas perangkat dan jenis sensor yang digunakan. JENIS_SENSOR menyimpan nama jenis pengukuran dan satuannya. PEMBACAAN_SENSOR menyimpan hasil pengukuran berdasarkan waktu.

PANEN digunakan sebagai tabel penghubung antara LAHAN dan KOMODITAS karena satu lahan dapat menghasilkan beberapa komoditas dan satu komoditas dapat dipanen dari beberapa lahan.
