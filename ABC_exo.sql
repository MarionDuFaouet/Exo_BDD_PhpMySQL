
// Mets à jour un prix 
UPDATE `produit` SET `PU`= 2.20 WHERE `RefProduit`=1
UPDATE `produit` SET `PU`= 4.80 WHERE `RefProduit`=12


// applique -5% à prix dès lors que prix est sup à 10
UPDATE `produit` SET `PU`= `PU`*0.95 WHERE `PU` IS NOT NULL and `PU`>10


// supprimer une données
DELETE FROM `tables` WHERE `NumeroTable`=15;
DELETE FROM `serveur` WHERE `IDServeur`=2


//débrayer et rembrayer les contraintes
SET GLOBAL FOREIGN_key_checks = 0
SET GLOBAL FOREIGN_key_checks = 1

//insérer plusieurs valeurs en une seule commande (cours OCR)
INSERT INTO `utilisateur` (`nom`, `prenom`, `email`)
VALUES
('Doe', 'John', 'john@yahoo.fr'),
('Smith', 'Jane', 'jane@hotmail.com'),
('Dupont', 'Sebastien', 'sebastien@orange.fr'),
('Martin', 'Emilie', 'emilie@gmail.com');
