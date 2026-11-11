# EGE GFM 2027 — application indépendante

Projet pédagogique indépendant de `janagaleh.com`.

## État au 11 novembre 2026

- **Cloudflare** : un Worker `ege-gfm-2027` est créé et son sous-domaine activé.
- **Application publiée** : version élève HTML (travail local, recherche documentaire gratuite Wikipédia, exports Word).
- **GitHub** : il reste à créer un dépôt **privé** `ege-gfm-2027` et à y envoyer ces fichiers.
- **Supabase** : un projet séparé doit être créé après sélection de l'organisation et accord sur le tarif éventuel.
- **Administration à distance** : NON ACTIVE; ne pas distribuer le fichier local d'administration comme panel sécurisé.
- **IA avec recherche approfondie** : non configurée; ne jamais inscrire une clé API secrète dans `index.html`.

## Structure

- `index.html` : application élève autonome, sans connexion Supabase.
- `scripts/deploy-cloudflare.mjs` : outil de publication du même HTML dans un Worker.
- `.github/workflows/deployment.yml` : publication manuelle avec GitHub Actions.
- `supabase/schema.sql` : proposition de base sécurisée par règles RLS, non appliquée.

## Créer le dépôt GitHub

1. Aller sur https://github.com/new et créer `ege-gfm-2027` en mode **Private**.
2. Télécharger puis décompresser ce projet et envoyer son contenu dans le dépôt.
3. Dans GitHub, Settings → Secrets and variables → Actions, définir :
   - `CLOUDFLARE_ACCOUNT_ID` : identifiant du compte Cloudflare.
   - `CLOUDFLARE_API_TOKEN` : jeton Cloudflare limité à l'édition des Workers.
4. Ouvrir Actions → « Deployer EGE sur Cloudflare » → « Run workflow ».

Ne mettez **jamais** vos clés secrètes dans des fichiers publics ou dans un message de conversation.

## Supabase (phase suivante)

Créer un projet distinct dans l'organisation choisie. Après accord sur le coût éventuel, appliquer le SQL dans le **nouveau projet uniquement** et exécuter les vérifications de sécurité. Installer ensuite une véritable connexion élève et une interface d'administration qui respecte les rôles et permissions.

**Important** : la création du schéma ne connecte pas automatiquement le HTML à Supabase. L'authentification et la synchronisation restent à développer et tester.

## Respect du dossier pédagogique

Le document Word conserve le gabarit pédagogique, avec validation obligatoire des sources. Ne pas inventer de données issues des visites d'entreprises.