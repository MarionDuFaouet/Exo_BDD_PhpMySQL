-- ma future convention d'écriture : les titres de tables en Capitalize et 
-- nom de colonnes en camelCase 


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
SELECT * FROM `produit`;


-- 2/afficher les descriptions et prix unitaires des produits entre 4 et 5 euros inclus
SELECT `description`,`PU` FROM `produit` WHERE (`PU` >= 4 AND `PU`<= 5);


-- 3/afficher les commandes datées du 13 mai 2022. 
SELECT DATE_FORMAT(`Dates`, '%D %b %Y'), `numeroCommande` FROM `commande` WHERE `Dates` = '2022-05-13';


-- 4/afficher les commandes (identifiant du serveur, date formatée, numéro de commande) rangées par serveur et par date.
SELECT `numeroCommande`, `IDServeur`, DATE_FORMAT(`Dates`, "%D %b %Y") FROM `commande` ORDER BY `IDServeur`, `Dates`; 


-- 5/afficher le nombre de commandes par date.
SELECT COUNT(*) AS 'nbCommande', `Dates` FROM `commande` GROUP BY `Dates`; 


-- 6/afficher le prix moyen des produits de la carte quand ceux-ci valent plus de 5 €.
SELECT FORMAT(AVG(`PU`),2) AS 'avgPrice' FROM `produit` AS p WHERE p.`PU`<5;


-- 7/afficher le nombre moyen de commandes par jour.
-- imbrication de méthode
-- nb il faut un renommage à la fin (AS grouped)
-- correction Thierry
SELECT AVG(nbCmdPerDate) AS 'Nb moyen commande par date'
FROM(
    SELECT COUNT(*) AS nbCmdPerDate
    FROM `Commande`GROUP BY `Dates`
) AS grouped;


-- 8/afficher les nom et prénom du serveur qui gère la table numéro 7
-- 8/correction Thierry
SELECT `serveur`.`prenom`,`serveur`.`nom` 
FROM `serveur` 
JOIN `tables` 
ON `tables`.`IDServeur`=`serveur`.`IDServeur` 
WHERE `Table`.`numTable`=7;
-- 8/ou, si les clés primaires et secondaires ont le même nom (cas le plus courant)
SELECT `Serveur`.`prenom`,`Serveur`.`nom` 
FROM `Serveur` 
JOIN `Table` USING (`IDServeur`) 
WHERE `Table`.`numTable`=7;


-- 9/afficher les produits de la commande numéro 5 : leurs description, quantité et prix respectifs.
-- je peux afficher des colonnes venant de plusieurs tables
SELECT `produit`.`Description`, `contenir`.`quantite`, `produit`.`PU`
-- je veux afficher les produits
FROM `produit`
-- je joins à la table contenir, ces deux tables ont en commun la clé refProduit
JOIN `contenir` USING (`refProduit`)
-- je vise là où le numero de commande, dans la table contenir, est égal à 5
WHERE `contenir`.`numeroCommande` = 5;


-- 10/afficher les produits de la commande numéro 5 : leurs description, quantité et prix respectifs.
-- ajouter une colonne résultat qui contient le sous-total du prix par produit.
-- je peux ajouter un SUM dans mon SELECT
SELECT `produit`.`Description`, `contenir`.`quantite`, `produit`.`PU`, SUM(`contenir`.`quantite` * `produit`.`PU`) AS 'sous-total'
FROM `produit`
JOIN `contenir` USING (`refProduit`)
WHERE `contenir`.`numeroCommande`=5
GROUP BY `produit`.`refProduit`;


-- 11/en repartant de la question précédente, trouver le montant total de la commande 5.
SELECT `numeroCommande`, SUM(`contenir`.`quantite` * `produit`.`PU`)
FROM `produit`
JOIN `contenir` USING (`refProduit`) 
WHERE `contenir`.`numeroCommande`=5; 


-- 12/trouver le chiffre d'affaire dégagé par chaque serveur (son identifiant)
SELECT `IDServeur`, SUM(`contenir`.`quantite` * `produit`.`PU`) 
FROM `produit`
JOIN `contenir` USING (`refProduit`) 
JOIN `commande` USING (`numeroCommande`) 
GROUP BY `IDServeur`; 

















-- BONUS ++---------------------------------------------------------------------------


-- 13/en repartant de la question précédente, remplacer l'identifiant du serveur par son prénom/nom.
SELECT `serveur`.`prenom`, `serveur`.`nom`, SUM(`contenir`.`quantite` * `produit`.`PU`)
FROM `serveur`, `Produit`
JOIN `contenir` USING (`refProduit`)
JOIN `commande` USING (`numeroCommande`)
WHERE `serveur`.`IDServeur`= `commande`.`IDServeur`
GROUP BY `commande`.`IDServeur`;

-- 14/affichage des produits du plus vendu au moins vendu (en terme de quantité).
FROM `contenir`
INNER JOIN `produit` ON `contenir`.`refProduit` = `produit`.`refProduit`
GROUP BY `produit`.`refProduit`
ORDER BY topProduct DESC LIMIT 25;

-- 15/trouver le chiffre d'affaires par table
SELECT `table`.`numeroTable`, SUM(`contenir`.`quantite` * `produit`.`PU`) AS`CA`
FROM `table`, `produit`
JOIN `contenir` USING (`refProduit`)
JOIN `commande` USING (`numeroCommande`)
WHERE `commande`.`numeroTable`= `table`.`numeroTable`
GROUP BY `commande`.`numeroTable`
ORDER BY `CA`;
