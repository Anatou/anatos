# AnatOs
AnatOs est mon framework de configuration NixOs. Il a pour vocation d'être le dernier OS que je touche sérieusement: une config pour les gouverner tous. Le but est de pouvoir facilement l'utiliser sur tous futurs systèmes (workstation, servers, etc...). 

Pour accomplir ce digne objectif, il faut dé-corréler les hosts, les users, et les configurations des programmes. En effet, je pourrais vouloir utiliser le même utilisateur *anatou* sur plusieurs *hosts*, en gardant les mêmes programmes et configurations. Ou alors utiliser sur un même *host* plusieurs *users* différents. Dans un premier temps, je vais m'efforcer de développer une configuration *mono-user*, en effet, je n'ai pas l'utilité du *multi-user* pour l'instant. En revanche, il est toujours utile de séparer *user* et *system* pour découpler le *user-space* du *system-space*.
 
Ainsi un *user* est configuré avec ses programmes, son DE, et ses paramètres. Il peut être activé sur un *host* en l'ajoutant à la liste des *users* de ce *host*.

Ce framework n'a pas pour but d'être partagé et documenté que le serait  [zaneyos](https://gitlab.com/Zaney/zaneyos). Tout choix n'est motivé que part ce qu'il m'est agréable et utile.

# Structure du framework
Pour toutes les présentation de structure de fichiers suivante, le fichier `default.nix` sera systématiquement omis. Cela réduit le bruit visuel et facilite la lecture. Voici la structure simplifiée du framework: 
```files
hosts/
  ├─ host1/
  └─ ...
modules/Structure de fichiers
  ├─ devshells/
  ├─ home/
  ├─ scripts/
  └─ system/
users/
  ├─ user1/
  └─ ...
flake.nix
README.md
```

# `flake.nix`

Peut-être faire une construction fonctionnelle du système avec 
``` nix
let 
	mkConfig: x: y: {
	
	}
in
	mkConfig param1 param2
```


# `hosts/`
Les hosts (aka machines) sous AnatOs. Chaque host configure le système supportant les utilisateurs. C'est à dire les question comme le bootloader, les packages/programmes globaux au système, les drivers, la wifi/bluetooth, le volume...

Un dossier de *host* ressemble à la structure standard d'une configuration nix
```files
host1/
  ├─ configuration.nix
  └─ hardware.nix
```


# `modules/`
Les modules sont des ressources communes utilisables par les *hosts* et les *users*. On en distingues plusieurs types: scripts, devshells, programmes, services... En voici la structure des dossiers:
```files
devshells/
  ├─ devshell1.nix
  └─ ...
home/
  ├─ programs/
  └─ services/
scripts/
  ├─ script1.nix
  └─ ...
system/
  ├─ programs/
  └─ services/
```

## `devshells/`
Dossier contenant toutes mes nix development shells. Je peux facilement les copier de là pour les utiliser. Une piste d'amélioration possible est d'utiliser des symlinks pour synchroniser les éventuels changements.

## `home/`
Dossiers contenant les programmes et services utilisateurs. Chaque programme/service est configuré dans un ou plusieurs fichier contenant le programme/écosystème. Cette partie du framework fonctionne grâce au système de *home-manager*. Des programmes utilisateurs sont par exemple *git*, *zsh*, ou même *hyprland* et son écosystème. Voici la structure des dossiers:
```files
programs/
  ├─ subfolder1/
  │    ├─ user-program2.nix
  │    └─ ...
  ├─ user-program1.nix
  └─ ...
services/
  ├─ user-service1.nix
  └─ ...
```

## `scripts/`
Dossiers contenant tous les scripts utiles au framework. De l'instantiation d'un nouvel utilisateur, à la mise à jour du système. 

## `system/`
Dossiers contenant les programmes et services système. Chaque programme/service est configuré dans un ou plusieurs fichier contenant le programme/écosystème. Des programmes systèmes sont par exemple *pipewire* ou *bluez*. Voici la structure des dossiers:
```files
programs/
  ├─ subfolder1/
  │    ├─ system-program2.nix
  │    └─ ...
  ├─ system-program1.nix
  └─ ...
services/
  ├─ system-service1.nix
  └─ ...
```

# `users/`
Les utilisateurs sous AnatOs. Chaque utilisateur configure ses programmes utilisés, ses services, son DE, son style, ses variables. C'est un endroit fréquemment modifié. 

Un dossier *user* suit la structure suivante
```files
user1/
  ├─ configuration.nix
  ├─ home.nix
  └─ variables.nix
```

Le fichier `configuration.nix` configure l'utilisateur au niveau du système (shell, DE, groups). Les modifications de ce fichiers sont appliqués par une rebuild de nixos. Le fichier `home.nix` configure les programes et dotfiles de l'utilisateurs. Les modifications de ce fichiers sont appliqués par un rebuild de home-manager (ainsi l'utilisateur peut modifier son environnement en *rootless*). 


# Structure complète du framework
Encore une fois, les `default.nix` sont omis pour la clarté visuelle.
```files
anatos/
  ├─ hosts/
  │    ├─ host1/
  │    │    ├─ system-configuration.nix
  │    │    └─ hardware.nix
  │    └─ ...
  ├─ modules/
  │    ├─ devshells/
  │    │    ├─ devshell1.nix
  │    │    └─ ...
  │    ├─ home/
  │    │    ├─ programs/
  │    │    │    ├─ user-pgrogram1.nix
  │    │    │    └─ ...
  │    │    └─ services/
  │    │         ├─ user-service1.nix
  │    │         └─ ...
  │    ├─ scripts/
  │    │    ├─ script1.nix
  │    │    ├─ script2.sh
  │    │    └─ ...
  │    └─ system/
  │         ├─ programs/
  │         │    ├─ system-pgrogram1.nix
  │         │    └─ ...
  │         └─ services/
  │              ├─ system-service1.nix
  │              └─ ...
  ├─ users/
  │    ├─ user1/
  │    │    ├─ user-configuration.nix
  │    │    └─ ...
  │    └─ ...
  ├─ flake.nix
  └─ README.md
```