-- =====================================================================
-- Undian Doorprize — setup database Supabase
-- Jalankan sekali di Supabase: Dashboard → SQL Editor → New query → Run
-- =====================================================================

-- 1) Salinan lengkap data undian (tamu, hadiah, pemenang, SBU, pengaturan).
--    Satu baris per acara; dipakai untuk memulihkan data di laptop lain.
create table if not exists public.undian_state (
  id          text primary key,                 -- kode acara, mis. 'mekar-bersama'
  data        jsonb not null,
  updated_at  timestamptz not null default now()
);

-- 2) Daftar pemenang, satu baris per pemenang — untuk laporan & rekap panitia.
create table if not exists public.undian_pemenang (
  id          text primary key,                 -- kode_acara:id_hadiah:id_peserta
  event       text not null,                    -- kode acara
  prize_no    integer,
  prize_name  text,
  pool        text not null default 'tamu',     -- 'tamu' atau 'sbu'
  guest_id    text,
  nama        text not null,
  keterangan  text,                             -- kolom lain dari file unggahan (mis. waktu absensi)
  status      text not null default 'menang',   -- 'menang' atau 'gugur' (tidak hadir)
  waktu       timestamptz not null default now()
);
create index if not exists undian_pemenang_event_idx on public.undian_pemenang (event, prize_no);

-- 3) Akses dari halaman undian (memakai anon / publishable key).
--    CATATAN KEAMANAN: siapa pun yang memegang anon key + URL proyek bisa
--    membaca & mengubah dua tabel ini. Cukup untuk acara internal; jangan
--    bagikan file HTML yang sudah berisi key ke luar panitia.
alter table public.undian_state    enable row level security;
alter table public.undian_pemenang enable row level security;

drop policy if exists "undian_state anon all"    on public.undian_state;
drop policy if exists "undian_pemenang anon all" on public.undian_pemenang;
create policy "undian_state anon all"    on public.undian_state    for all to anon using (true) with check (true);
create policy "undian_pemenang anon all" on public.undian_pemenang for all to anon using (true) with check (true);

-- 4) Hak akses tabel untuk role anon (publishable key).
--    Proyek Supabase baru tidak otomatis memberi izin ini → tanpa GRANT
--    halaman akan mendapat error "permission denied for table ...".
grant usage on schema public to anon;
grant select, insert, update, delete on public.undian_state    to anon;
grant select, insert, update, delete on public.undian_pemenang to anon;

-- 5) Catatan: setiap browser menyimpan datanya sendiri.
--    id di undian_state dan kolom event di undian_pemenang berbentuk 'mekar-bersama:<id-browser>'.
--    Nama perangkat ada di undian_state.data->>'deviceName'.

-- Daftar browser yang menyimpan data:
-- select id, data->>'deviceName' as perangkat, updated_at,
--        jsonb_array_length(data->'winners') as jumlah_pemenang
-- from public.undian_state where id like 'mekar-bersama:%' order by updated_at desc;

-- Rekap pemenang semua browser:
-- select p.event, s.data->>'deviceName' as perangkat, p.prize_no, p.prize_name, p.nama, p.keterangan, p.waktu
-- from public.undian_pemenang p left join public.undian_state s on s.id = p.event
-- where p.event like 'mekar-bersama:%' and p.status = 'menang'
-- order by perangkat, p.prize_no, p.waktu;
