# GenerateDataStructure

L'obiettivo principale del codice è quello di estrarre e strutturare le risposte fisiologiche e
i dati dell'eyetracker dei partecipanti durante la visualizzazione di meme specifici.

## Parametri e Configurazioni
pysiologicalColumns: Elenco delle colonne che formeranno la struttura dati.
MEMEs_PER_PARTICIPANT: Numero di meme visualizzati da ogni partecipante.
MAIN_FOLDER: Cartella principale contenente i dati.
SAMPLE_FREQ: Frequenza di campionamento.
MEM_TIME_ON_SET: Durata, in secondi, di ciascun intervallo di tempo associato a un meme.

### Dati di Input
Il codice si basa su dati forniti dai seguenti file CSV e XLSX:
- **initialQuestionnaire.csv**: Questionario iniziale dei partecipanti.
- **partecipanti.xlsx**: Informazioni sui partecipanti.
- **random_groups.xlsx**: Gruppi casuali associati agli ID dei meme.

## Funzionamento Principale
Carica i dati relativi ai meme, ai partecipanti e ai gruppi casuali di meme.

Itera attraverso le sottocartelle dei soggetti e carica i dati fisiologici, i marker dei meme 
precedentemente allineati e i dati di EPrime.

Estrae i segmenti dei dati fisiologici correlati a ciascun meme.

Al termine dell'esecuzione saranno presenti le seguenti strutture dati:
- **memesData**:  struttura dati contenente tutte le informazioni relative ai Meme. __[numeroMeme x 10 table]__
- **participantsData**:   struttura dati contenente tutte le informazioni relative ai partecipanti. __[numeroPartecipanti x 1 cell]__
- **groupTable**:   tabella contenente tutti i gruppi random. 
                    Ogni colonna contiene gli id dei meme del gruppo che ha come numero l'indice 
                    della colonna 
- **linker**:   struttura dati che collega gli indici dei partecipanti con i corrispondenti indici 
                dei Meme __[(numeroMeme x numeroPArtecipanti) x 2]__


## Sviluppi futuri 

Il codice dovrebbe eseguire operazioni di filtraggio, normalizzazione prima della suddivisione 
dei dati fisiologici in base agli intervalli temporali associati ai meme.
