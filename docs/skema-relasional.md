1. KABUPATEN
kabupaten(id_kabupaten, nama_kabupaten)

FK:
- Tidak ada.


2. PENGGUNA
pengguna(id_pengguna, nama, email, password_hash, peran, id_kabupaten)

FK:
- id_kabupaten -> kabupaten.id_kabupaten


3. KOMODITAS
komoditas(id_komoditas, nama_komoditas, satuan)

FK:
- Tidak ada.


4. LAHAN
lahan(id_lahan, nama_lahan, luas_hektar, latitude, longitude, id_kabupaten, id_pengguna)

FK:
- id_kabupaten -> kabupaten.id_kabupaten
- id_pengguna -> pengguna.id_pengguna


5. HARGA_KOMODITAS
harga_komoditas(id_harga, tanggal, harga_per_kg, id_komoditas, id_kabupaten)

FK:
- id_komoditas -> komoditas.id_komoditas
- id_kabupaten -> kabupaten.id_kabupaten


6. ESTIMASI_HARGA
estimasi_harga(id_estimasi, tanggal_estimasi, harga_estimasi, arah_perubahan, id_komoditas, id_kabupaten)

FK:
- id_komoditas -> komoditas.id_komoditas
- id_kabupaten -> kabupaten.id_kabupaten


7. SENSOR
sensor(id_sensor, kode_sensor, tanggal_pasang, status, id_lahan)

FK:
- id_lahan -> lahan.id_lahan


8. PANEN
panen(id_panen, tanggal_panen, jumlah_kg, id_lahan, id_komoditas)

FK:
- id_lahan -> lahan.id_lahan
- id_komoditas -> komoditas.id_komoditas


9. PEMBACAAN_SENSOR
pembacaan_sensor(id_pembacaan, waktu_baca, kelembapan_tanah, ph_tanah, suhu, kelembapan_udara, cuaca, id_sensor)

FK:
- id_sensor -> sensor.id_sensor


10. PREDIKSI_PANEN
prediksi_panen(id_prediksi, tanggal_prediksi, estimasi_hasil_kg, tingkat_risiko, id_lahan, id_komoditas)

FK:
- id_lahan -> lahan.id_lahan
- id_komoditas -> komoditas.id_komoditas


11. PERINGATAN_DINI
peringatan_dini(id_peringatan, waktu_peringatan, pesan, id_prediksi)

FK:
- id_prediksi -> prediksi_panen.id_prediksi