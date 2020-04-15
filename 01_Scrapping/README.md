# Scraping avec Python

## Les étapes du web scrapping
Les étapes essentielles pour faire du web scraping :
1.	Définition des urls initiales
2.	Parsing des pages 
3.	Extraction des données 
4.	Extractions des URLs à suivre
5.	Traitement des données
La structure d’un site web

Avant de commencer le scraping, il faut avoir quelques notions de base concernant la structure d’un site web. 

Pour cela, vous pouvez utiliser l’inspecteur d’un navigateur, par exemple Chrome : sur n’importe quelle page web, vous faites un clic droit, et vous cliquez sur « Inspecter ».  Ensuite, vous pouvez ensuite « inspecter » un élément spécifique. Dans la console, vous verrez ainsi toute la structure de la page : les données sont extrêmement structurées, avec les balises comme header, body, div, span, a, h1, etc. Pour différencier ces balises et leur donner des fonctionnalités, vous verrez qu’elles peuvent avoir des classes, id, href, etc.

## La difficulté du scraping
La principale difficulté dans le scraping est que les sites disposent rarement de la même structure. De plus, les pages web sont régulièrement mises à jour, avec toutes les modifications du code source que cela peut entrainer.

Par exemple, si l’on considère 

## Les librairies Python

* BeautifulSoup : Suffisant quand vous voudrez travailler sur des pages HTML statiques
* Selenium: Utilse lorsque les informations recherchées sont générées via l’exécution de scripts Javascipt,
* urllib	
* Scrapy : Crawler
	
Il existe beaucoup de librairie Python pour faire du scraping. Selon les pages visitées ou les projets à mener, certaines seront plus utiles que d’autres. Il convient de faire appels à la communauté de développer (Forum, site spécialisé…) et aux réponses déjà présentes sur le web pour se faire une idée des packages à utiliser.
Un exemple avec les Open Data Italie

## Exemple avec les données Open Data Italie
Les données en Open Data pour l’Italie sont catalogués sur le site suivant : Lien. Ces bases de données sont répertoriées et classées selon différentes thématiques : 
-	Art et culture
-	Commerce
-	Travail
-	…

En cliquant sur une ou l’autre de ces catégories, on se rend compte que l’URL des pages web se modifie. Par exemple : 
-	Art et culture : http://www.datiopen.it/it/catalogo-opendata/arte-cultura
-	Commerce : http://www.datiopen.it/it/catalogo-opendata/commercio-0
-	Travail : http://www.datiopen.it/it/catalogo-opendata/lavoro-0
-	…

Les résultats sont présents sur plusieurs page web, elles même indicées. Par exemple (pour la catégorie « Commerce  ») :

Du coup, il est possible  d’obtenir une URL pour  chaque page : 
-	Page 1 : http://www.datiopen.it/it/catalogo-opendata/commercio-0?page=0 
-	Page 2 : http://www.datiopen.it/it/catalogo-opendata/commercio-0?page=1 
-	Page 3 : http://www.datiopen.it/it/catalogo-opendata/commercio-0?page=2 
-	Page 4 : http://www.datiopen.it/it/catalogo-opendata/commercio-0?page=3 
-	…

On constate alors que l’URL est composé d’éléments fixes et variables et peut etre décomposé de la manière suivante : 

“http://www.datiopen.it/it/catalogo-opendata/” + theme + “?page=” + index

Où theme et index sont des variables déclarées par l’utilisateur.
