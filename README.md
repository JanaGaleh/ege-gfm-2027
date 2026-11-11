# EGE GFM 2027 — application indépendante

Assistant pédagogique pour les Études de Gestion Encadrées, session 2027 à Djibouti.
Ce dépôt est distinct de `janagaleh.com` et de `Mon Bac`.

## État des connexions — 11 novembre 2026

- **GitHub** : dépôt créé, application et fichiers de configuration transférés et vérifiés.
- **Cloudflare** : Worker `ege-gfm-2027` créé et sous-domaine `workers.dev` activé ; liaison automatique GitHub → Cloudflare encore à autoriser.
- **Supabase** : schéma préparé dans `supabase/schema.sql`, mais **aucun nouveau projet créé et aucun SQL exécuté**.
- **Administration à distance** : non active. Ne pas publier l'ancien panneau local comme portail administrateur sécurisé.
- **Recherche documentaire** : recherche publique Wikipédia dans l'HTML ; le mode de rédaction IA via API sécurisée n'est pas encore configuré.

## Fichiers

- `index.html` : parcours élève autonome (sauvegarde locale et export Word).
- `scripts/deploy-cloudflare.mjs` : publication manuelle du HTML sur le Worker Cloudflare.
- `.github/workflows/deployment.yml` : workflow de déploiement **manuel**, nécessite deux secrets GitHub.
- `supabase/schema.sql` : base EGE isolée et politiques RLS proposées, à contrôler avant usage en production.
- `.gitignore` : exclusion des fichiers de secrets.

## Connexion Cloudflare – GitHub (recommandé)

1. Cloudflare → **Workers & Pages** → Worker `ege-gfm-2027`.
2. **Settings** → **Builds** → **Connect** → **GitHub**.
3. Autoriser le dépôt `JanaGaleh/ege-gfm-2027`.
4. Configurer un déploiement adapté au projet ; avant activation automatique, **tester une publication**.

L'alternative est le workflow GitHub Actions. Il faut alors ajouter dans
GitHub → Settings → Secrets and variables → Actions :
`CLOUDFLARE_API_TOKEN` (jeton de portée minimale Workers Scripts Write)
et `CLOUDFLARE_ACCOUNT_ID`, puis lancer le workflow manuellement.
**Ne pas inscrire ces valeurs dans le dépôt, les issues ou les conversations.**

## Supabase (prochaine phase)

Après confirmation de l'organisation Supabase et de l'éventuel coût, créer
un projet **distinct**. Vérifier ensuite les règles RLS du schéma, relier le
navigateur via une clé publiable et créer un espace d'administration avec rôle sécurisé.
**Aucune clé service_role ne doit figurer dans un fichier HTML.**

## Données EGE

- 6 thèmes, 51 sous-thèmes du référentiel officiel.
- Dossier Word basé sur le modèle de référence.
- Recherche documentaire à vérifier par le candidat.
- Aucune donnée de visite, entretien ou entreprise inventée.

## Sécurité

Ce dépôt a été constaté comme **public** : le rendre privé si le code doit être réservé.
Les dossiers personnels des élèves ne doivent jamais être committés dans GitHub.
