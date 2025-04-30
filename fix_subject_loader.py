# Script pour corriger le fichier SubjectLoader.py
with open('SubjectLoader.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Trouver l'index de la dernière accolade fermante correcte
last_valid_index = content.rfind('            ]')

# Ajouter la fin correcte du fichier
fixed_content = content[:last_valid_index+13]  # +13 pour inclure les espaces et le crochet

# Écrire le contenu corrigé
with open('SubjectLoader.py', 'w', encoding='utf-8') as f:
    f.write(fixed_content)

print("Le fichier SubjectLoader.py a été corrigé avec succès.")
