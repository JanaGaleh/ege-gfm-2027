-- Extension additive pour Supabase mon-bac. Aucune table Mon Bac existante n'est modifiée.
-- Ne jamais donner au client HTML une clé service_role.
create table if not exists public.ege2027_staff (
 user_id uuid primary key references auth.users(id) on delete cascade,
 role text not null default 'enseignant' check (role in ('enseignant','admin')),
 created_at timestamptz not null default now()
);
alter table public.ege2027_staff enable row level security;
create table if not exists public.ege2027_dossiers (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null unique references auth.users(id) on delete cascade,
 student text not null default '',
 payload jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists ege2027_dossiers_updated_idx on public.ege2027_dossiers(updated_at desc);
alter table public.ege2027_dossiers enable row level security;
create table if not exists public.ege2027_reviews (
 id uuid primary key default gen_random_uuid(),
 dossier_id uuid not null references public.ege2027_dossiers(id) on delete cascade,
 staff_id uuid not null references auth.users(id),
 decision text not null check (decision in ('a_corriger','valide')),
 observation text not null default '',
 created_at timestamptz not null default now()
);
create index if not exists ege2027_reviews_dossier_idx on public.ege2027_reviews(dossier_id,created_at desc);
alter table public.ege2027_reviews enable row level security;
drop policy if exists ege2027_staff_self_read on public.ege2027_staff;
create policy ege2027_staff_self_read on public.ege2027_staff for select to authenticated using(user_id=(select auth.uid()));
drop policy if exists ege2027_dossiers_read on public.ege2027_dossiers;
create policy ege2027_dossiers_read on public.ege2027_dossiers for select to authenticated
 using(owner_id=(select auth.uid()) or exists(select 1 from public.ege2027_staff s where s.user_id=(select auth.uid())));
drop policy if exists ege2027_dossiers_insert on public.ege2027_dossiers;
create policy ege2027_dossiers_insert on public.ege2027_dossiers for insert to authenticated with check(owner_id=(select auth.uid()));
drop policy if exists ege2027_dossiers_update on public.ege2027_dossiers;
create policy ege2027_dossiers_update on public.ege2027_dossiers for update to authenticated
 using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
drop policy if exists ege2027_reviews_read on public.ege2027_reviews;
create policy ege2027_reviews_read on public.ege2027_reviews for select to authenticated using(
 exists(select 1 from public.ege2027_staff s where s.user_id=(select auth.uid()))
 or exists(select 1 from public.ege2027_dossiers d where d.id=dossier_id and d.owner_id=(select auth.uid())));
drop policy if exists ege2027_reviews_insert on public.ege2027_reviews;
create policy ege2027_reviews_insert on public.ege2027_reviews for insert to authenticated with check(
 staff_id=(select auth.uid()) and exists(select 1 from public.ege2027_staff s where s.user_id=(select auth.uid())));
revoke all on public.ege2027_staff,public.ege2027_dossiers,public.ege2027_reviews from anon;
revoke all on public.ege2027_staff,public.ege2027_dossiers,public.ege2027_reviews from authenticated;
grant select on public.ege2027_staff to authenticated;
grant select,insert on public.ege2027_dossiers to authenticated;
grant update(student,payload,updated_at) on public.ege2027_dossiers to authenticated;
grant select,insert on public.ege2027_reviews to authenticated;
-- Pour autoriser un enseignant, faire uniquement depuis SQL après avoir vérifié son auth.users.id.
