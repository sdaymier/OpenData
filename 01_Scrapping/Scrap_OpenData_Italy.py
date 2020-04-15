# ########################################################################
# Etape  0 : Initialisation de l'environnement
# ########################################################################

# Librairie necessaire pour la lecture des URL et le parsing
# ------------------------------------------------------------------------
from bs4 import BeautifulSoup
import urllib

# Enregistrement des differentes categorie
# ------------------------------------------------------------------------
# Remarque : peuvent etre recuperer dynamiquement
# ------------------------------------------------------------------------
allcat = ["scienza-tecnologia", "sociale", "sport-tempo-libero","territorio", "turismo-0", "istruzione-0", "infrastrutture-trasporti", "economia", "commercio-0"]

# Affichage 
allcat[0]   # scienza-tecnologia
len(allcat) # 9

# Variable pour les incrementations : 
# ------------------------------------------------------------------------
nb= 9 # Nombre de page (peut etre cree dynamiquement)
i = 0 # Initialisation de la boucle

# ########################################################################
# Etape 1 : Declaration des variables dynamiques
# ########################################################################
# Recuperation du nom de la categorie parmis la liste precedemment definie
# ------------------------------------------------------------------------
allcat = ["scienza-tecnologia", "sociale", "sport-tempo-libero","territorio", 
          "turismo-0", "istruzione-0", "infrastrutture-trasporti", "economia", 
          "commercio-0"]
category = allcat[8]

# Affichage de la catégorie en cours de traitement
# ------------------------------------------------------------------------
print "*** " + category + " ***" 

# Construction de l'URL pour la categorie selectionnee
# ------------------------------------------------------------------------
url = "http://www.datiopen.it/it/catalogo-opendata/" + category # + "-0"

# ########################################################################
# Etape  2 : Recuperation des informations sur les pages de resultats
# ########################################################################
while i < nb:
    # Creation de l'url pour la page i
    url2 = url + "?page=" + str(i)
    # Affichage
    print url2 
    
# ########################################################################
# Etape 3 : Lecture de l'url
# ########################################################################
    r = urllib.urlopen(url2).read()
    
# ########################################################################
# Etape 4 : Parser pour récupérer les infos
# ########################################################################
    soup = BeautifulSoup(r, "lxml",from_encoding="utf-8")
    tempo = soup.find_all("div", class_="search-result-sx") # resultat pour la page i
    # Initialisation pour le premier tour
    if i==0:
        letters = tempo
    else: 
        letters = letters + tempo
    # print len(letters) # 20 résultats par page donc incrément len += 20 (sauf pour la dernière page)
    i+=1 # Fin de la boucle
    
# ########################################################################
# Etape 5 : Construction du dictionnaire pour sauvegarder les resultats
# ########################################################################
# Definition des keys
# ------------------------------------------------------------------------
lobbying = {}
for element in letters:
    lobbying[element.a.get_text()] = {}
print len(lobbying.keys()) # Check nombre keys : 160 keys 

# Remplissage du dictionnaire
# ------------------------------------------------------------------------
for element in letters:
    lobbying[element.a.get_text()]["Country"] = "Italy"
    lobbying[element.a.get_text()]["Category"] = category
    # Provider de la bdd
    name = element.find('span', attrs={'class': 'author-label'})  
    lobbying[element.a.get_text()]["Provider"] = name.text.strip()
    # Label de la bdd
    lobbying[element.a.get_text()]["Label"] = element.a["title"]
    
    lobbying[element.a.get_text()]["link"] = element.a["href"]

    name = element.find('div', attrs={'class': 'search-item-tags'})
    lobbying[element.a.get_text()]["Issues"] = name.text.strip().replace("Tematiche:\t\t  \t\n\n\n\r\n\t\t\t\t\t","")

# Change the default encoding of the whole script to be ‘UTF-8’
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

# ########################################################################
# Etape 5 : Enregistrer les resultats en CSV
# ########################################################################
import os, csv
os.chdir("C:/Users/Admin/Desktop/Sarah_DAYMIER/01_Review_Open_Data_by_country/Italy")
    
with open(category + ".csv", "w") as toWrite:
    writer = csv.writer(toWrite, delimiter=";")
    writer.writerow(["Label","Country", "Category", "Provider","link","Issues"])
    for a in lobbying.keys():
        unicode("Éléphant", "utf-8")
        writer.writerow([lobbying[a]["Label"],
                         lobbying[a]["Country"], 
                         lobbying[a]["Category"], 
                         lobbying[a]["Provider"], 
                         lobbying[a]["link"], 
                         lobbying[a]["Issues"]
                        ])
print "FIN"
