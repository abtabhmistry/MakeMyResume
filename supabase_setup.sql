-- Run this in Supabase SQL Editor after creating a project.
create table if not exists public.candidate_submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  candidate_name text not null,
  candidate_email text,
  phone text,
  resume_data jsonb not null default '{}'::jsonb,
  photo_path text,
  consent_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.candidate_submissions enable row level security;
create or replace function public.is_nursecv_admin() returns boolean
language sql stable security definer set search_path = '' as $$
  select coalesce((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin', false);
$$;
revoke all on function public.is_nursecv_admin() from public;
grant execute on function public.is_nursecv_admin() to authenticated;
drop policy if exists "candidate reads own submission or admin reads all" on public.candidate_submissions;
create policy "candidate reads own submission or admin reads all" on public.candidate_submissions for select to authenticated using (auth.uid() = user_id or public.is_nursecv_admin());
drop policy if exists "candidate inserts own submission" on public.candidate_submissions;
create policy "candidate inserts own submission" on public.candidate_submissions for insert to authenticated with check (auth.uid() = user_id and consent_at is not null);
drop policy if exists "candidate updates own submission or admin updates all" on public.candidate_submissions;
create policy "candidate updates own submission or admin updates all" on public.candidate_submissions for update to authenticated using (auth.uid() = user_id or public.is_nursecv_admin()) with check (auth.uid() = user_id or public.is_nursecv_admin());
-- Storage bucket for candidate photos. Private means no public URL.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('candidate-photos', 'candidate-photos', false, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=false, file_size_limit=5242880, allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "candidate uploads own photo" on storage.objects;
create policy "candidate uploads own photo" on storage.objects for insert to authenticated with check (bucket_id = 'candidate-photos' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "candidate reads own photo or admin reads all" on storage.objects;
create policy "candidate reads own photo or admin reads all" on storage.objects for select to authenticated using (bucket_id = 'candidate-photos' and ((storage.foldername(name))[1] = auth.uid()::text or public.is_nursecv_admin()));
drop policy if exists "candidate updates own photo" on storage.objects;
create policy "candidate updates own photo" on storage.objects for update to authenticated using (bucket_id = 'candidate-photos' and (storage.foldername(name))[1] = auth.uid()::text) with check (bucket_id = 'candidate-photos' and (storage.foldername(name))[1] = auth.uid()::text);
