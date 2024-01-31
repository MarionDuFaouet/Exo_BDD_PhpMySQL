
-- Mets à jour un prix 
UPDATE `produit` SET `PU`= 2.20 WHERE `RefProduit`=1
UPDATE `produit` SET `PU`= 4.80 WHERE `RefProduit`=12


-- applique -5% à prix dès lors que prix est sup à 10
UPDATE `produit` SET `PU`= `PU`*0.95 WHERE `PU` IS NOT NULL and `PU`>10


-- supprimer une données
DELETE FROM `tables` WHERE `NumeroTable`=15;
DELETE FROM `serveur` WHERE `IDServeur`=2


-- débrayer et rembrayer les contraintes
SET GLOBAL FOREIGN_key_checks = 0
SET GLOBAL FOREIGN_key_checks = 1

-- /insérer plusieurs valeurs en une seule commande (cours OCR)
INSERT INTO `utilisateur` (`nom`, `prenom`, `email`)
VALUES
('Doe', 'John', 'john@yahoo.fr'),
('Smith', 'Jane', 'jane@hotmail.com'),
('Dupont', 'Sebastien', 'sebastien@orange.fr'),
('Martin', 'Emilie', 'emilie@gmail.com');




-- 1/afficher tous les produits disponibles sur la carte
-- Pourquoi ça m'affiche quelques serveurs?
SELECT `description` FROM `produit`;
-- 2/afficher les descriptions et prix unitaires des produits entre 4 et 5 euros inclus
SELECT `description`,`PU` FROM `produit` WHERE `PU` >= 4 AND `PU`>= 5;
-- 3/afficher les commandes datées du 13 mai 2022. 
SELECT DATE_FORMAT("2022-05-13", "%D %b %Y"), `numeroCommande` FROM `commande` WHERE `Dates` = "2022-05-13";
-- 4/afficher les commandes (identifiant du serveur, date formatée, numéro de commande) rangées par serveur et par date.
SELECT `numeroCommande`, `IDServeur`, DATE_FORMAT(`Dates`, "%D %b %Y") FROM `commande` GROUP BY `IDServeur`, `Dates`; 
-- 5/afficher le nombre de commandes par date.
SELECT COUNT(*), `Dates` FROM `commande` GROUP BY `Dates`; 

-- 6/afficher le prix moyen des produits de la carte quand ceux-ci valent plus de 5 €.
SELECT AVG(`PU`) FROM `produit` WHERE `PU` >5;
-- 7/afficher le nombre moyen de commandes par jour.
-- pas réussi
SELECT AVG(COUNT (*)), `Dates` FROM `commande` GROUP BY `Dates`

SELECT AVG(nb)
FROM (
    SELECT COUNT(*) AS nb
    FROM `commande`
)     GROUP BY `Dates`


-- 8/afficher les nom et prénom du serveur qui gère la table numéro 7
SELECT `IDServeur`,`nom`,`prenom` FROM `serveur` JOIN `tables` ON `tables.IDServeur`=7;

-- 9/afficher les produits de la commande numéro 5 : leurs description, quantité et prix respectifs.
-- 10/en repartant de la question précédente, ajouter une colonne résultat qui contient le sous-total du prix par produit.
-- 11/en repartant de la question précédente, trouver le montant total de la commande 5.
-- 12/trouver le chiffre d'affaire dégagé par chaque serveur (son identifiant)
-- 13/en repartant de la question précédente, remplacer l'identifiant du serveur par son prénom/nom.
-- 14/affichage des produits du plus vendu au moins vendu (en terme de quantité).
-- 15/trouver le chiffre d'affaires par table