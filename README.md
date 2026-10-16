# Sistem Undian Doorprize — MEKAR BERSAMA · PLN Icon Plus

Halaman web satu file (`undian-doorprize.html`) untuk mengundi doorprize dan grand prize dari daftar tamu yang hadir, ditampilkan di layar besar dengan animasi, dan disimpan di laptop serta Supabase.

---

## 1. Daftar file

| File | Fungsi |
|---|---|
| `undian-doorprize.html` | Aplikasi undian (cukup dibuka di browser, tidak perlu server). Logo PLN Icon Plus sudah tertanam di dalam file. |
| `supabase-setup.sql` | Membuat tabel, aturan keamanan (RLS), dan hak akses di Supabase. Jalankan sekali. |
| `supabase-grant.sql` | Versi singkat khusus hak akses (GRANT + RLS) untuk tabel yang sudah ada. |
| `peserta-absen.csv` | Contoh daftar tamu format absensi: `waktu, nama` (2.000 baris, tanpa judul kolom). |
| `peserta-contoh.csv` | Contoh daftar tamu dengan judul kolom: `No, Nama, Unit, No Undangan` (2.000 baris). |

---

## 2. Kebutuhan

- Browser modern: Google Chrome atau Microsoft Edge (disarankan).
- Internet **disarankan**, untuk:
  - font Montserrat & Playfair Display (Google Fonts) — tanpa internet memakai font bawaan sistem;
  - library pembaca Excel (SheetJS) — tanpa internet, unggah daftar tamu dalam format **CSV**;
  - library animasi Lottie (opsional);
  - sinkronisasi Supabase — tanpa internet data tetap tersimpan di laptop dan dikirim otomatis saat koneksi kembali.
- Output layar: **1920×1080** disarankan. Sudah diuji di 1280×720, 1366×768, 1440×900, 1920×1080, dan 4K (3840×2160, otomatis diperbesar merata).

---

## 3. Persiapan sebelum acara

### 3.1 Supabase (sekali saja)
1. Buka Supabase → **SQL Editor** → **New query**.
2. Tempel isi `supabase-setup.sql` → **Run**. (Jika tabel sudah ada dan muncul error *permission denied*, jalankan `supabase-grant.sql`.)
3. Buka `undian-doorprize.html` → tab **Data** → **↻ Tes koneksi**. Penanda di header harus menjadi **☁ Tersimpan**.

Konfigurasi Supabase tertanam di kode (`undian-doorprize.html`, bagian *KONFIGURASI SUPABASE*):

```js
const SUPABASE_URL   = 'https://yhlsjiujzskilbjqetth.supabase.co';
const SUPABASE_KEY   = 'sb_publishable_…';   // publishable key (aman untuk halaman web)
const SUPABASE_EVENT = 'mekar-bersama';      // kode acara
```

> Jangan pernah memakai **secret key** (`sb_secret_…`) atau **service_role key** di file ini.

### 3.2 Daftar tamu
1. Tab **Tamu** → klik / tarik file ke kotak unggah (CSV, TXT, atau Excel).
2. Kolom nama dikenali otomatis:
   - jika ada judul kolom `Nama` (atau `Name`, `Nama Lengkap`, `Nama Peserta`, …) → kolom itu dipakai;
   - jika tidak ada judul, dipilih kolom yang isinya paling banyak huruf (bukan jam/tanggal/angka).
3. Kolom lain (mis. waktu absensi) disimpan sebagai **keterangan** — tidak tampil di layar undian, tetapi ikut di CSV hasil & Supabase.
4. Unggah file lagi saat daftar sudah ada → pilih **Tambahkan ke daftar**, **Ganti (reset pemenang)**, atau **Batal**.

### 3.3 Hadiah
Daftar hadiah default sudah terisi (tab **Hadiah**). Total **233 hadiah**.

| No | Hadiah | Jumlah | Cara undi | Kategori |
|---:|---|---:|---|---|
| 14 | Voucher MAP @100.000 | 40 | Sekaligus | Doorprize |
| 13 | Voucher Tabungan Emas @250.000 | 20 | Sekaligus | Doorprize |
| 12 | Voucher Indomaret @100.000 | 40 | Sekaligus | Doorprize |
| 11 | Voucher Tabungan Haji @250.000 | 20 | Sekaligus | Doorprize |
| 10 | Powerbank | 24 | Sekaligus | Doorprize |
| 9 | Kompor Listrik | 10 | Sekaligus | Doorprize |
| 8 | Smartband | 10 | Sekaligus | Doorprize |
| 7 | Voucher MAP @50.000 | 25 | Sekaligus | Doorprize |
| 6 | Voucher Indomaret @50.000 | 30 | Sekaligus | Doorprize |
| 5 | Tablet | 7 | Sekaligus (kartu misteri) | Grand prize |
| 4 | Sepeda Listrik | 4 | Sekaligus (kartu misteri) | Grand prize |
| 3 | Motor Listrik | 1 | Satuan (reel) | Grand prize |
| 2 | Tablet (SBU) | 1 | Satuan (reel) | Undian khusus SBU |
| 1 | Sepeda Listrik (SBU) | 1 | Satuan (reel) | Undian khusus SBU |

**Urutan undian dari bawah ke atas**: no. 14 diundi pertama, no. 1 terakhir (tabel di atas sudah sesuai urutan acara). Urutan bisa diubah dengan tombol ↑ ↓ di tab Hadiah.

Pengaturan lain di tab Hadiah:
- **Satuan / Sekaligus** — klik label untuk mengganti cara undi.
- **Undian khusus SBU** — centang saat menambah hadiah agar pesertanya dari daftar SBU.
- **Peserta undian khusus SBU** — 9 SBU default (SUMBAGUT, SUMBAGSEL, SUMBAGTENG, JABAR, JATENG, JATIM, KALIMANTAN, BALI NUSRA, SULAWESI DAN IBT), satu per baris, bisa diedit.
- **Nama acara** — default `MEKAR BERSAMA`.
- **Animasi Lottie** (opsional) — unggah file `.json` dari LottieFiles untuk diputar saat pemenang grand prize muncul.
- **↺ Muat hadiah default** — mengembalikan daftar hadiah di atas.

---

## 4. Menjalankan undian saat acara

1. Atur output laptop ke 1920×1080, buka halaman, klik **⛶ Layar Penuh** (atau F11).
2. Tekan **Spasi** — cukup Spasi sampai acara selesai (±15 kali untuk daftar default).

Setiap tekan Spasi memajukan acara satu langkah:
- hadiah masih ada kuota → undi;
- kuota habis → lanjut ke hadiah berikutnya;
- semua hadiah selesai → layar ditutup.

### 4.1 Tampilan per jenis hadiah

| Jenis | Alur di layar |
|---|---|
| **Doorprize (sekaligus)** | Kartu nama diacak ±1,6 detik dengan drum roll → semua pemenang muncul bersamaan → fanfare, kembang api, ucapan *"Selamat kepada N Pemenang"*. |
| **Grand prize sekaligus** (Tablet, Sepeda Listrik) | Hitung mundur 3-2-1 → kartu misteri "?" → kartu dibuka satu per satu (efek putar 3D, bunyi ding, kembang api di tiap kartu) → kilatan emas, fanfare, hujan confetti. |
| **Grand prize satuan** (Motor Listrik) & **undian SBU** | Hitung mundur 3-2-1 → reel nama berputar dengan bunyi "tik" yang melambat → berhenti tepat di garis tengah → *Selamat!*, kembang api. |

Tata letak kartu:
- **≤ 40 pemenang**: semua tampil dalam satu layar, ukuran kartu & huruf otomatis sebesar mungkin; nama panjang diperkecil otomatis agar tidak terpotong.
- **> 40 pemenang**: daftar bergeser horizontal otomatis (berhenti saat kursor di atas daftar).

### 4.2 Pemenang tidak hadir
- **Undian sekaligus**: klik **✕** di kartu → konfirmasi **Gugurkan** → kartu hilang, nomor dirapikan → tekan Spasi / **Undi pengganti**.
- **Undian satuan**: klik **✕ Tidak hadir — undi ulang** → konfirmasi → reel diputar ulang.

Konfirmasi tampil di dalam halaman (tidak keluar dari layar penuh). **Enter** = setuju, **Esc** = batal.

### 4.3 Tombol keyboard

| Tombol | Fungsi |
|---|---|
| Spasi | Undi / undi berikutnya / lanjut ke hadiah berikutnya |
| Esc | Tutup layar undian (atau batalkan konfirmasi) |
| Enter | Setujui konfirmasi |

---

## 5. Aturan undian

- **Satu orang hanya satu hadiah.** Pemenang langsung dikeluarkan dari undian berikutnya; peserta yang digugurkan juga tidak ikut lagi.
- **Undian SBU terpisah** dari daftar tamu. Setiap SBU hanya bisa menang satu kali di antara hadiah SBU.
- Pengacakan memakai `crypto.getRandomValues` (acak kriptografis, tanpa bias). Pemenang ditentukan sebelum animasi dimulai; animasi hanya tampilan.

> ⚠ **Perhatian — nama ganda.** Peserta dihitung **per baris file**, bukan per nama. Jika satu orang muncul dua kali di file absensi (atau file yang sama diunggah lagi dengan *Tambahkan ke daftar*), orang itu punya dua peluang dan bisa menang dua kali. Bersihkan nama ganda di file sebelum diunggah.

---

## 6. Penyimpanan data

### 6.1 Di laptop (utama)
Semua data disimpan di `localStorage` browser setiap ada perubahan — undian tetap jalan tanpa internet dan data tidak hilang saat halaman di-refresh.

| Key localStorage | Isi |
|---|---|
| `undian_doorprize_v2` | Data utama: tamu, hadiah, pemenang, tamu gugur, SBU, nama acara, pengaturan suara |
| `undian_doorprize_lottie` | File animasi Lottie (jika diunggah) |
| `undian_browser_id` | ID browser ini untuk Supabase (mis. `b-faqljm`) |
| `undian_device_name` | Nama perangkat (mis. "Laptop Panggung") |
| `undian_sync_ops` | Antrean perubahan yang belum terkirim ke Supabase |

> Data terikat ke browser & file yang sama. Membersihkan data browser, mode Incognito, atau browser lain = mulai dari kosong (data bisa diambil lagi dari Supabase).

### 6.2 Di Supabase (salinan, per browser)
Setiap browser menyimpan datanya di baris sendiri, sehingga data browser lain tidak tertimpa.

**Tabel `undian_state`** — salinan lengkap per browser

| Kolom | Isi |
|---|---|
| `id` | `mekar-bersama:<id-browser>` |
| `data` | JSON lengkap (tamu, hadiah, pemenang, SBU, `deviceName`, `browserId`) |
| `updated_at` | Waktu terakhir tersimpan |

**Tabel `undian_pemenang`** — satu baris per pemenang, untuk rekap

| Kolom | Isi |
|---|---|
| `id` | `<event>:<id-hadiah>:<id-peserta>` |
| `event` | `mekar-bersama:<id-browser>` |
| `prize_no`, `prize_name` | Nomor & nama hadiah |
| `pool` | `tamu` atau `sbu` |
| `guest_id`, `nama`, `keterangan` | Data peserta (keterangan = kolom lain dari file, mis. waktu absen) |
| `status` | `menang` atau `gugur` |
| `waktu` | Waktu diundi |

Perilaku sinkronisasi:
- Perubahan dikirim ±1 detik setelah terjadi; jika gagal, dicoba lagi tiap 10–15 detik dan saat koneksi kembali.
- Penanda di header: **☁ Tersimpan** (hijau) · **Menyimpan…** (kuning) · **Offline · N menunggu** (merah) · **Lokal saja** (key belum diisi).
- **Reset undian** / **Ganti daftar tamu** juga mengosongkan rekap pemenang browser itu di Supabase.

Tab **Data**:
- **Nama perangkat** — label agar mudah dikenali.
- **↻ Tes koneksi**.
- **⬇ Ambil data dari Supabase** — pilih browser asal (nama perangkat, jumlah tamu & pemenang, waktu); data disalin ke browser ini, data asal tidak berubah.
- **⬆ Kirim ulang semua data**.

Contoh query rekap (SQL Editor Supabase):

```sql
-- Daftar browser yang menyimpan data
select id, data->>'deviceName' as perangkat, updated_at,
       jsonb_array_length(data->'winners') as jumlah_pemenang
from public.undian_state
where id like 'mekar-bersama:%'
order by updated_at desc;

-- Rekap pemenang semua browser
select s.data->>'deviceName' as perangkat, p.prize_no, p.prize_name, p.nama, p.keterangan, p.waktu
from public.undian_pemenang p
left join public.undian_state s on s.id = p.event
where p.event like 'mekar-bersama:%' and p.status = 'menang'
order by perangkat, p.prize_no, p.waktu;
```

### 6.3 Ekspor
Tab **Pemenang** → **⬇ Unduh CSV** (kolom: `No, Hadiah, Nama, Keterangan, Waktu`, UTF-8 dengan BOM agar rapi di Excel).

---

## 7. Tampilan & tema

- Tema **MEKAR BERSAMA**, warna dasar **Pantone 7477 C** (`#244C5A`) dan **Pantone 3135 C** (`#008EAA`); aksen kuning & merah dari logo PLN Icon Plus.
- Logo PLN Icon Plus di header, panggung layar penuh, dan layar undian; teks `© <tahun> ICONDIGI` di bagian bawah.
- Tipografi: Montserrat (teks), Playfair Display (judul hadiah & ucapan selamat).
- Suara dibuat dengan Web Audio (drum roll, tik roulette, ding, fanfare) — bisa dimatikan dengan tombol **🔊 Suara**.
- Layar di atas 1920×1080 tanpa skala OS (mis. LED/TV 4K) otomatis diperbesar merata.

---

## 8. Checklist hari-H

- [ ] Laptop terisi daya, output layar 1920×1080, mode tidur dimatikan.
- [ ] Buka `undian-doorprize.html` di Chrome/Edge (bukan Incognito).
- [ ] Tab **Data**: isi nama perangkat, **Tes koneksi** → ☁ Tersimpan.
- [ ] Unggah daftar tamu final; cek jumlah di tab **Tamu**; pastikan tidak ada nama ganda.
- [ ] Tab **Pemenang** kosong (jika masih ada sisa uji coba: **Reset undian**).
- [ ] Tab **Hadiah**: daftar & urutan benar (jika perlu **↺ Muat hadiah default**).
- [ ] Suara terhubung ke sound system; tes tombol **🔊 Suara**.
- [ ] **⛶ Layar Penuh** → tekan Spasi.
- [ ] Setelah acara: **⬇ Unduh CSV** sebagai arsip, cek rekap di Supabase.

---

## 9. Masalah umum

| Gejala | Penyebab & solusi |
|---|---|
| Header **Offline · N menunggu** | Internet putus atau Supabase menolak. Data aman di laptop; akan terkirim otomatis. Cek koneksi lalu **Tes koneksi**. |
| `permission denied for table …` | Hak akses belum diberikan → jalankan `supabase-grant.sql`. |
| `401 Invalid API key` | Key salah → periksa `SUPABASE_KEY`. |
| File Excel tidak terbaca | Tidak ada internet untuk library Excel → simpan sebagai CSV. |
| Daftar hadiah lama masih tampil | Data uji coba tersimpan → **Reset undian** lalu **↺ Muat hadiah default**. |
| Data hilang setelah ganti browser/laptop | Data per browser → tab **Data** → **⬇ Ambil data dari Supabase**. |
| Huruf judul berbeda | Google Fonts tidak termuat (offline) → otomatis memakai font sistem. |

---

## 10. Catatan teknis

- Satu file HTML berisi HTML, CSS, dan JavaScript (vanilla, tanpa framework). Logo disisipkan sebagai data URI base64.
- Library eksternal (CDN): SheetJS `xlsx@0.18.5`, `lottie-web@5.12.2`, Google Fonts.
- Supabase diakses langsung lewat REST API (PostgREST) dengan `fetch` — header `apikey`; upsert memakai `Prefer: resolution=merge-duplicates`.
- Konstanta penting di kode: `DEFAULT_PRIZES`, `DEFAULT_SBUS`, `DEFAULTS_VERSION` (naikkan jika daftar default diubah agar browser yang belum punya pemenang ikut memperbarui), `FIT_MAX = 40` (batas pemenang yang tampil satu layar), `SUPABASE_URL` / `SUPABASE_KEY` / `SUPABASE_EVENT`.
- Keamanan: publishable key + RLS terbuka untuk role `anon` pada dua tabel undian — cukup untuk acara internal; jangan bagikan file HTML ke luar panitia.
