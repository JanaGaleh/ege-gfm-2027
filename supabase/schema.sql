-- EGE GFM 2027 : à appliquer uniquement dans un NOUVEAU projet Supabase.
-- Créer le projet indépendant AVANT l'exécution de ce schéma.
-- Attribution du rôle ege_role=admin exclusivement par un administrateur sécurisé.

create table if not exists public.ege_profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 nom_complet text not null default '',
 etablissement text not null default '',
 classe text not null default '',
 created_at timestamptz not null default now()
);
create table if not exists public.ege_dossiers (
 id uuid primary key default gen_random_uuid(),
 eleve_id uuid not null references auth.users(id) on delete cascade,
 contenu jsonb not null default '{}'::jsonb,
 statut text not null default 'brouillon' check (statut in ('brouillon','soumis','a_corriger','valide')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists ege_dossiers_eleve_idx on public.ege_dossiers(eleve_id);
create table if not exists public.ege_revisions (
 id uuid primary key default gen_random_uuid(),
 dossier_id uuid not null references public.ege_dossiers(id) on delete cascade,
 relecteur_id uuid not null references auth.users(id),
 observations jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create index if not exists ege_revisions_dossier_idx on public.ege_revisions(dossier_id);

alter table public.ege_profiles enable row level security;
alter table public.ege_dossiers enable row level security;
alter table public.ege_revisions enable row level security;

drop policy if exists ege_profiles_select on public.ege_profiles;
create policy ege_profiles_select on public.ege_profiles for select to authenticated
 using (id=(select auth.uid()) or (select auth.jwt() -> 'app_metadata' ->> 'ege_role')='admin');
drop policy if exists ege_profiles_insert on public.ege_profiles;
create policy ege_profiles_insert on public.ege_profiles for insert to authenticated
 with check (id=(select auth.uid()));
drop policy if exists ege_profiles_update on public.ege_profiles;
create policy ege_profiles_update on public.ege_profiles for update to authenticated
 using (id=(select auth.uid())) with check (id=(select auth.uid()));

drop policy if exists ege_dossiers_select on public.ege_dossiers;
create policy ege_dossiers_select on public.ege_dossiers for select to authenticated
 using (eleve_id=(select auth.uid()) or (select auth.jwt() -> 'app_metadata' ->> 'ege_role')='admin');
drop policy if exists ege_dossiers_insert on public.ege_dossiers;
create policy ege_dossiers_insert on public.ege_dossiers for insert to authenticated
 with check (eleve_id=(select auth.uid()) and statut='brouillon');
drop policy if exists ege_dossiers_update on public.ege_dossiers;
create policy ege_dossiers_update on public.ege_dossiers for update to authenticated
 using (
   (eleve_id=(select auth.uid()) and statut in ('brouillon','a_corriger'))
   or (select auth.jwt() -> 'app_metadata' ->> 'ege_role')='admin'
 )
 with check (
   (eleve_id=(select auth.uid()) and statut in ('brouillon','soumis'))
   or (select auth.jwt() -> 'app_metadata' ->> 'ege_role')='admin'
 );

drop policy if exists ege_revisions_select on public.ege_revisions;
create policy ege_revisions_select on public.ege_revisions for select to authenticated
 using (
   (select auth.jwt() -> 'app_metadata' ->> 'ege_role')='admin'
   or exists(select 1 from public.ege_dossiers d where d.id=dossier_id and d.eleve_id=(select auth.uid()))
 );
drop policy if exists ege_revisions_insert on public.ege_revisions;
create policy ege_revisions_insert on public.ege_revisions for insert to authenticated
 with check (
  (select auth.jwt() -> 'app_metadata' ->> 'ege_role')='admin'
  and relecteur_id=(select auth.uid())
 );
revoke all on public.ege_profiles, public.ege_dossiers, public.ege_revisions from anon;
grant select, insert, update on public.ege_profiles, public.ege_dossiers to authenticated;
grant select, insert on public.ege_revisions to authenticated;

-- Vérifier RLS avec deux comptes élèves et un compte admin avant toute ouverture publique.
-- Ne jamais placer service_role ou une clé secrète dans le fichier HTML.
