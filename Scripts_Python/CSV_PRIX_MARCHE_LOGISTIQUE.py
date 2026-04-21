import pandas as pd

chemin = r"C:\Users\ATCHOM\Pictures\CIC_DB\fusion_1\prix_cacao_bourse.csv"
chemin2 = r"C:\Users\ATCHOM\Pictures\CIC_DB\fusion_1\declaration_douane_export.csv"
chemin3 = r"C:\Users\ATCHOM\Pictures\CIC_DB\fusion_1\releves_banque.csv"
df1=pd.read_csv(chemin, encoding='utf-8')
df2=pd.read_csv(chemin2, encoding='utf-8')
df3=pd.read_csv(chemin3,encoding='latin1',sep=';')
# Concaténer verticalement (ignorer l'index d'origine)
#df_fusion = pd.concat([df1, df2, df3], ignore_index=True)
# Concaténer Horizontalement
#-------------------------------------#
df_fusion_h = pd.concat([df1.reset_index(drop=True),
                                  df2.reset_index(drop=True),
                                  df3.reset_index(drop=True)], axis=1)
print(df_fusion_h.head())
#-------------------------------------#
# Sauvegarder le résultat1\
df_fusion_h.to_csv(r'C:C:\\CIC_Github\\CSV_PRIX_MARCHE_LOGISTIQUE.csv', index=False,encoding='utf-8-sig')