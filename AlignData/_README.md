# alignData_ePrimeMarker.m

Il codice esegue la sincronizzazione dei marker manuali con i marker creati utilizzando i dati di EPrime.
Permette di visualizzare e salvare i grafici dei dati ficiologici con i marker sovrapposti. 

## Funzionamento Principale

Itera su tutte le sottocartelle in MAIN_FOLDER.
Carica i dati di ePrime, dello shimmer e dei marker manuali se esistono.

Effettua la sincronizzazione tra i dati acquisiti da un dispositivo (shimmer) e i dati di un'esperimento (EPrime).
La sincronizzazione temporale tra dati manuali e dati acquisiti è gestita attraverso un offset allineando i primi due marcatori.

Crea vettori di marcatori per gli eventi di interesse (inizio della visualizzazione dei meme, inizio resting time).

Salva i vettori dei marker nella stessa sottocartella dei dati del soggetto.

## Parametri e Configurazioni

MAIN_FOLDER: Directory principale contenente i dati.
SAMPLE_FREQ: Frequenza di campionamento.
SAVE_PLOT: Flag per il salvataggio dei grafici.
VIEW_PLOT: Flag per la visualizzazione dei grafici.

## Visualizzazione dei Grafici:

Se settati gli opportuni flag, crea un grafico contenente informazioni sulle conduttanze cutanee, i marker manuali e i marker di ePrime.

Salva il grafico se abilitato il flag SAVE_PLOT.

Vengono utilizzate funzioni esterne come loadData, splitShimmerData, e createManualMarker.


