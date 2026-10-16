-- Jalankan di Supabase → SQL Editor → New query → Run
-- Memberi izin publishable key (role anon) untuk membaca & menulis tabel undian.
grant usage on schema public to anon;
grant select, insert, update, delete on public.undian_state    to anon;
grant select, insert, update, delete on public.undian_pemenang to anon;

-- Pastikan RLS aktif & kebijakan akses tersedia (aman dijalankan ulang)
alter table public.undian_state    enable row level security;
alter table public.undian_pemenang enable row level security;
drop policy if exists "undian_state anon all"    on public.undian_state;
drop policy if exists "undian_pemenang anon all" on public.undian_pemenang;
create policy "undian_state anon all"    on public.undian_state    for all to anon using (true) with check (true);
create policy "undian_pemenang anon all" on public.undian_pemenang for all to anon using (true) with check (true);
