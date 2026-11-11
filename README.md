# EGE GFM 2027 — application indépendante

Application pédagogique autonome du site janagaleh.com, avec son propre dépôt GitHub et son Worker Cloudflare.

## Backend retenu : Supabase mon-bac EXISTANT

- Référence du projet : `nwcatsmfbkcgvgbanwyl`
- URL publique Supabase : `https://nwcatsmfbkcgvgbanwyl.supabase.co`
- Clé dans l'HTML : **clé publiable uniquement**, jamais service_role.
- Comptes Supabase Auth partagés avec le projet Mon Bac ; les dossiers EGE sont isolés par RLS.
- Tables nouvelles proposées : `ege2027_staff`, `ege2027_dossiers`, `ege2027_reviews`.
- **Aucune table Mon Bac existante ne doit être renommée, supprimée ou modifiée.**

## État au 11 novembre 2026

- GitHub : code et interface Supabase transférés dans `index.html`.
- Cloudflare : Worker `ege-gfm-2027` déjà créé ; la synchronisation GitHub → Cloudflare n'est pas automatique.
- Supabase Mon Bac : le projet est administrativement ACTIVE_HEALTHY, **mais les requêtes SQL échouent avec `Connection terminated due to connection timeout`**. L'API health signale également `hibernated`.
- La tentative de migration a échoué à l'initialisation de son historique. **La création effective des tables n'est donc pas confirmée**.
- En conséquence, **sauvegarde en ligne, suivi des corrections et administration distante ne sont PAS opérationnels tant que la migration n'est pas appliquée et testée**.
- La sauvegarde locale JSON, la recherche documentaire publique et l'export Word restent disponibles dans le code existant.

## Fichiers importants

- `index.html` : interface élève et espace Compte/Administration, prête à utiliser Mon Bac quand le schéma sera opérationnel.
- `supabase/schema.sql` : migration additive, tables et policies RLS.
- `scripts/deploy-cloudflare.mjs` : script de publication en ligne, appelé par un workflow GitHub manuel.
- `.github/workflows/deployment.yml` : GitHub Actions (secrets Cloudflare à fournir si utilisé).

## Pour terminer la mise en service

1. Dans [Supabase Dashboard](https://supabase.com/dashboard/project/nwcatsmfbkcgvgbanwyl), vérifier Database Reports / Project Health.
2. Une fois la base accessible, appliquer et tester `supabase/schema.sql` **dans le projet mon-bac**.
3. Vérifier les permissions RLS avec deux élèves différents et un enseignant.
4. Ajouter un enseignant autorisé dans `ege2027_staff` avec son identifiant `auth.users.id` validé ; aucun rôle admin n'est auto-attribué.
5. Publier et tester l'`index.html` actualisé sur Cloudflare (le Worker actuel a été publié avant la connexion Supabase).
6. Raccorder ensuite GitHub à Cloudflare, ou configurer les deux secrets du workflow manuel.

## Sécurité

Le dépôt est actuellement public. La clé Supabase publiable peut être exposée car elle ne donne pas les privilèges d'administration : ce sont les politiques RLS qui protègent les données. **Ne jamais insérer une clé service_role / secret dans le HTML ou dans GitHub.**
Les données personnelles des élèves ne doivent jamais être committées dans le dépôt.

La première version ne prétend pas effectuer une synchronisation automatique ni une connexion complète tant que l'accès SQL Supabase demeure indisponible.
