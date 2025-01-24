// Import and init Codly - better codeblocks
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#let icon(codepoint) = {
  box(
    height: 0.8em,
    baseline: 0.05em,
    image(codepoint)
  )
  h(0.1em)
}
#codly(languages: codly-languages)

#set text(lang: "pl")
#set heading(numbering: "1.")
#set page(numbering: "1", margin: (x: 2.5cm, y: 2.5cm))
#set par(justify: true, leading: 0.8em, linebreaks: "optimized", first-line-indent: 1em)
#set block(spacing: 1.45em, above: 1.3em, below: 1.3em)
// Set font and color for inline code
#show raw: set text(font: "JetBrains Mono", fill: rgb(60, 163, 88, 255))
// Change color of figure's captions
#show figure: set text(fill: rgb(80, 80, 80, 255), style: "italic")


/* --- End of configuration --- */

#align([
  #text([#smallcaps("Politechnika Rzeszowska")\ ], size: 1.2em)
  #text([#smallcaps("Wydział Elektrotechniki i Informatyki")\ ], size: 1em)

  #image("./images/weii.png", width: 11cm)

  #text([Sztuczna Inteligencja\ ], size: 1.2em, weight: "bold")
  #text([Klasyfikator win w Burn\ ], size: 1.5em, weight: "black")
  #text([Projekt\ ], size: 1em, weight: "bold")
], center + horizon)

#align(grid(
  columns: (auto, 1fr),
  [#align(text("24.01.2025 r.", size: 0.8em), end)],
  [#align(text(smallcaps("Kamil Pomykała, 174725"), size: 1.1em), end)],
), right + bottom)

#set align(start + top)

#pagebreak()

#outline(indent: true)

// Set heading font. Needs to be set after outline
#show heading: it => [
  #set block(above: 1.75em, below: 0em)
  #set text(weight: "bold", size: 1.35em)
  #text(it)
]

#pagebreak()

= Opis problemu

\

Klasyfikacja win, polegająca na przypisaniu konkretnego trunku do właściwej odmiany winogron na podstawie jego
parametrów chemicznych, odgrywa ważną rolę w analizie jakości oraz unikalnych cech wina. Zróżnicowanie cech win pod
względu składu chemicznego sprawia, że klasyfikacja win jest trudnym zadaniem.

Dzięki nowoczesnym rozwiązaniom, takim jak sztuczna inteligencja i algorytmy uczenia głębokiego, możliwe jest
zautomatyzowanie procesu klasyfikacji win. Problem ten można sprowadzić do zadania wieloklasowej klasyfikacji,
w którym model, analizując cechy takie jak zawartość alkoholu, poziom kwasowości czy intensywność barwy,
jest w stanie rozpoznać odmianę winogron wykorzystaną do produkcji danego wina.

== Istota problemu

\

Klasyfikacja win na podstawie ich składu chemicznego ma znaczenie zarówno dla producentów, jak i konsumentów.
Dla producentów stanowi narzędzie umożliwiające kontrolę jakości, identyfikację charakterystycznych cech produktu
oraz optymalizację procesów wytwarzania. Z kolei dla konsumentów wiedza o właściwościach wina pozwala na lepsze
dopasowanie do indywidualnych preferencji smakowych.

Automatyzacja tego procesu za pomocą modeli sztucznej inteligencji nie tylko przyspiesza i ułatwia analizę, ale również
 otwiera nowe możliwości w zakresie badań nad różnorodnością win oraz ich właściwościami.

== Technologiczne aspekty rozwiązania

\

Zastosowanie sztucznej inteligencji, w szczególności algorytmów uczenia maszynowego, stanowi kluczowy element w procesie
automatycznej klasyfikacji win. Nowoczesne techniki, takie jak sieci neuronowe czy głębokie uczenie (Deep Learning),
umożliwiają modelom analizowanie złożonych wzorców w danych chemicznych, które są trudne do wychwycenia przez
tradycyjne metody.

Do implementacji tych sieci najczęściej wykorzystuje się popularne biblioteki, takie jak `PyTorch` i `TensorFlow`, które
oferują szeroki zestaw narzędzi do budowy, trenowania i optymalizacji sieci neuronowych. Dodatkowo, `Burn`, biblioteka
stworzona w języku `Rust`, staje się coraz bardziej popularną alternatywą do bibliotek w językach wysokopoziomowych,
dzięki swojej wydajności i możliwościach języka niskopoziomowego.

#pagebreak()
== Cel projektu

\

Celem projektu jest opracowanie modelu sztucznej inteligencji, który będzie w stanie automatycznie klasyfikować wina na
podstawie ich cech chemicznych. Projekt zakłada stworzenie systemu wykorzystującego algorytmy głębokiego uczenia,
który na podstawie danych, precyzyjnie przypisze wino do jednej z określonych odmian. Dążymy do opracowania modelu o
wysokiej dokładności, który może zostać wykorzystany zarówno w badaniach naukowych, jak i w przemyśle winiarskim do
automatycznej klasyfikacji produktów.

= Opis części praktycznej

== Uczenie modelu

\

Uczenie modelu w kontekście Deep Learningu polega na wykorzystaniu zaawansowanych algorytmów sztucznej inteligencji,
szczególnie sieci neuronowych, do rozpoznawania wzorców i zależności w danych. _Deep Learning_, będący poddziedziną
uczenia maszynowego, różni się od tradycyjnych metod uczenia maszynowego tym, że automatycznie wykonuje proces
ekstrakcji cech z surowych danych, bez potrzeby ręcznego selekcjonowania istotnych atrybutów. Proces ten odbywa się
dzięki warstwom sieci neuronowych, które są odpowiedzialne za stopniowe przekształcanie danych wejściowych na
reprezentacje coraz bardziej złożone.

Uczenie modelu odbywa się w procesie zwanym treningiem, który polega na minimalizowaniu funkcji błędu.
Funkcja ta mierzy, jak bardzo przewidywania modelu różnią się od rzeczywistych etykiet w danych. Podczas treningu sieć
neuronowa iteracyjnie dostosowuje swoje parametry (_wagi i biasy_), aby jak najlepiej odwzorować prawdziwe dane wyjściowe.
Używa się tutaj algorytmu optymalizacji, najczęściej *spadku gradientu* (_Gradient Descent_), który pozwala na
modyfikację wag w taki sposób, by minimalizować błąd predykcji.

W procesie tym kluczową rolę odgrywa funkcja aktywacji, która wprowadza nieliniowość do modelu i pozwala na modelowanie
bardziej złożonych zależności. Przykładowe funkcje aktywacji to *ReLU* (_Rectified Linear Unit_), *sigmoida* czy *tanh*,
które pomagają w decyzji, czy dane wejściowe mają być uwzględnione w obliczeniach w danej warstwie.

W trakcie treningu model uczy się generalizować, czyli wykrywać ogólne wzorce, które będą skuteczne nie tylko dla danych
treningowych, ale także dla nowych, niewidzianych wcześniej przykładów. Aby uniknąć przeuczenia (_overfitting_),
stosuje się techniki, takie jak regularizacja, *_dropout_* czy *_early stopping_*, które pomagają utrzymać model w równowadze
pomiędzy dokładnością a zdolnością do uogólniania.

== Nadzorowane uczenie

\

Uczenie nadzorowane to metoda uczenia maszynowego, w której model jest trenowany na danych wejściowych, które są już
przypisane do odpowiednich klas (czyli wyników). W przypadku klasyfikacji win oznacza to, że dla każdego przykładu
(wina) znamy już jego kategorię, czyli odmianę winogron, z której pochodzi. Model wykorzystuje te informacje, aby
nauczyć się, jak przypisać nowe, nieznane dane do właściwej klasy.

W procesie uczenia modelu, sieć neuronowa analizuje cechy chemiczne wina (takie jak zawartość alkoholu, kwasowość,
intensywność barwy itp.), a następnie na podstawie tych danych podejmuje decyzję, do której z trzech odmian winogron
należy dane wino. Model jest trenowany na wcześniej oznaczonych danych (winach o znanych odmianach), a celem jest
minimalizacja błędu klasyfikacji, aby przewidywania modelu były jak najbardziej dokładne.

== Ocena skuteczności modelu

\

Testowanie modelu polega na sprawdzeniu jego zdolności do poprawnego przypisywania nowych, niewidzianych wcześniej
danych do odpowiednich klas. W tym przypadku model, który został wytrenowany na danych zawierających cechy chemiczne
win, jest testowany na osobnym zbiorze testowym, który nie był używany w trakcie treningu. Celem jest ocena, jak
dobrze model generalizuje swoje umiejętności na nowych danych, a nie tylko na tych, które były obecne w zestawie
treningowym.

Podczas testowania modelu ocenia się jego skuteczność przy pomocy odpowiednich metryk, takich jak *dokładność*
(_accuracy_), która wskazuje, jaka część wszystkich przewidywań była poprawna oraz *strata* (_loss_), która określa,
jak dobrze model radzi sobie z minimalizacją błędów w klasyfikacji.

=== Dokładność

\

Dokładność modelu to procent poprawnych przewidywań w stosunku do wszystkich przewidywań. Im wyższa wartość dokładności,
tym lepsza jest skuteczność modelu. Na przykład, jeśli model przewidział poprawnie $90$ z $100$ próbek, to jego
dokładność wynosi $90%$. Dokładność jest jedną z najczęściej stosowanych metryk w problemach klasyfikacji, ponieważ jest
intuicyjna i łatwa do interpretacji.

$
"Accuracy" = frac("Liczba poprawnych przewidywań", "Liczba wszystkich próbek")
$

=== Strata

\

*Strata* (_loss_) to wartość funkcji błędu, która mierzy, jak bardzo przewidywania modelu różnią się od rzeczywistych
etykiet w danych.

Dla problemu klasyfikacji, jedną z najczęściej stosowanych funkcji _loss_ jest *_cross-entropy loss_*, która mierzy
różnicę między przewidywaną a rzeczywistą rozkładem prawdopodobieństw dla poszczególnych klas. Im mniejsza wartość
_loss_, tym lepsza jest skuteczność modelu, ponieważ oznacza to, że przewidywania modelu są bardziej zbliżone
do rzeczywistych etykiet.

#pagebreak()

= Analiza danych wejściowych

\

Analiza danych wejściowych to kluczowy etap w każdym projekcie uczenia maszynowego, który pozwala na zrozumienie
struktury danych, ich właściwości oraz przygotowanie ich do dalszego przetwarzania i trenowania modelu. W tym przypadku,
celem analizy jest dokładne zrozumienie cech chemicznych win, które stanowią podstawę do klasyfikacji różnych odmian
winogron.

== Opis zbioru danych

\

Zbiór danych, który jest wykorzystywany w tym projekcie, pochodzi z analizy chemicznej win pochodzących z tego samego
regionu we Włoszech, ale z trzech różnych odmian winogron. Zawiera on 13 cech chemicznych, które zostały zmierzone dla
każdego z win, takich jak zawartość alkoholu, kwasowość, intensywność barwy oraz inne właściwości, które wpływają na
charakterystykę wina. W zbiorze danych znajdują się również etykiety, które informują o rodzaju odmiany winogron,
z której pochodzi dane wino.

Dokładnym źródłem danych jest _"PARVUS - An Extendible Package for Data Exploration, Classification
and Correlation"_. Instytut Analiz Farmaceutycznych i Żywnościowych oraz Technologii, Genua, Włochy. To źródło dostarcza
narzędzie o nazwie PARVUS, które jest pakietem rozszerzalnym do eksploracji danych, klasyfikacji i analizy korelacji.
Zostało opracowane przez zespół badaczy w Instytucie, który specjalizuje się w analizach farmaceutycznych
i żywnościowych. Pakiet ten umożliwia dokładną analizę chemiczną win i może być używany do różnych celów badawczych,
w tym klasyfikacji różnych rodzajów win.

== Struktura zbioru danych

\

Każdy wiersz w zbiorze danych reprezentuje jedno wino, a 13 kolumn odpowiada różnym cechom chemicznym, które zostały
zmierzone w próbce. Wartości w tych kolumnach są liczbowe, co oznacza, że dane są już w formie numerycznej, gotowe do
dalszego przetwarzania. Również warto wspomnieć, że nie ma brakujących danych w zbiorze, co ułatwia analizę.

Zbiór danych podzielony jest na 178 próbek, a liczby próbek dla poszczególnych odmian winogron to:

- Klasa 1: $59$ próbek - $(33.1%)$
- Klasa 2: $71$ próbek - $(39.9%)$
- Klasa 3: $48$ próbek - $(27.0%)$

Atrybuty chemiczne, które zostały zmierzone dla każdego wina, to:

+ *Alkohol* – Zawartość alkoholu w winie, wyrażona jako procent objętości alkoholu w stosunku do całkowitej objętości płynu. Jest to jeden z kluczowych wskaźników wpływających na smak i charakterystykę wina.
+ *Kwas jabłkowy* – Zawartość kwasu jabłkowego w winie. Jest to naturalny kwas organiczny, który wpływa na smak wina, nadając mu kwaskowatość. Wina o wyższej zawartości tego kwasu mogą być bardziej kwasowe i orzeźwiające.
+ *Popiół* – Zawartość popiołu w winie, który jest pozostałością po spaleniu organicznych składników w winie. Zawartość popiołu może mieć wpływ na mineralność wina.
+ *Zasadowość popiołu* – Określa poziom zasadowości popiołu w winie. Zasadowość wpływa na pH wina i może oddziaływać na smak, zwłaszcza w kontekście równowagi kwasowości i słodyczy.
+ *Magnez* – Zawartość magnezu w winie. Magnez jest jednym z minerałów, który wpływa na smak wina, a jego obecność może wpływać na ogólną jakość i strukturę wina.
+ *Całkowita zawartość fenoli* – Fenole są naturalnymi związkami organicznymi występującymi w winie, które odpowiadają za smak, zapach oraz właściwości zdrowotne wina. Ich zawartość może wpływać na goryczkę oraz astringencję wina.
+ *Flawanoidy* – Jest to grupa fenoli, która wpływa na smak, zapach i kolor wina. Flawanoidy są również antyoksydantami, co ma znaczenie dla trwałości wina.
+ *Fenole nieflawanoidowe* – Inna grupa fenoli, która nie należy do flawanoidów, ale również wpływa na smak i zapach wina, nadając mu specyficzne cechy organoleptyczne.
+ *Proantocyjaniny* – Związki odpowiedzialne za kolor wina, zwłaszcza czerwonych win. Są to silne antyoksydanty, które również wpływają na strukturę smaku i astringencję.
+ *Intensywność koloru* – Określa głębokość koloru wina, co jest ważnym atrybutem w przypadku win czerwonych i białych. Intensywność koloru może wskazywać na dojrzałość wina oraz jego skład chemiczny.
+ *Odcień* – Dotyczy barwy wina, który może się różnić w zależności od odmiany winogron, procesu fermentacji i starzenia wina. Odcień jest kluczowym elementem oceny jakości wina.
+ *OD280/OD315 rozcieńczonych win* – Stosunek absorbancji przy długości fali 280 nm do 315 nm, który jest wykorzystywany do oceny jakości i zawartości substancji organicznych w winie, takich jak fenole.
+ *Prolina* – Aminokwas występujący w winie, który wpływa na strukturę wina oraz jego stabilność. Zawartość proliny może mieć wpływ na właściwości smakowe i chemiczne wina.

= Przygotowanie danych do nauki

\

Odpowiednie przygotowanie danych ma na celu zapewnienie, że model będzie w stanie uczyć się skutecznie i osiągać jak
najlepsze wyniki. W tym etapie dokonuje się kilku istotnych operacji, takich jak czyszczenie danych, normalizacja,
dodanie brakujących wartości, podział na zbiory treningowe i testowe, a także inne techniki, które pomagają w
dostosowaniu danych do wymagań modelu.

Poniżej przedstawię kroki, które ja podjąłem w celu przygotowania danych do trenowania modelu klasyfikacji win.

== Czyszczenie danych

\

Pierwszym krokiem w przygotowaniu danych jest ich czyszczenie, czyli usunięcie zbędnych informacji, brakujących wartości
czy duplikatów. W przypadku zbioru danych, który został wykorzystany w tym projekcie, nie było potrzeby usuwania
żadnych próbek. Każdy atrybut może potencjalnie wpłynąć na klasyfikację wina, dlatego nie ma potrzeby eliminacji.

== Normalizacja danych

\

Normalizacja danych jest ważnym krokiem w przypadku modeli, które wykorzystują algorytmy uczenia maszynowego, ponieważ
pozwala na ujednolicenie skali wartości atrybutów. W przypadku zbioru danych z cechami chemicznymi win, wartości
poszczególnych atrybutów różnią się znacząco, co może wpłynąć na proces uczenia modelu.

Np. zawartość alkoholu w winie mieści się w zakresie od $11.0%$ do $14.8%$, podczas gdy zawartość kwasu jabłkowego
waha się od $1.74$ do $4.23$. Aby uniknąć problemów związanych z różnicą w skali wartości, zastosowałem normalizację.

W procesie normalizacji dane są przeskalowane w taki sposób, aby mieściły się w określonym zakresie.
W moim przypadku od $-1$ do $1$.

\

#{
  show raw: set text(size: 0.9em)
  figure(
    [$x_"norm" = frac(2 * (x - x_min), x_max - x_min) - 1$],
    caption: "Normalizacji danych do zakresu [-1, 1]",
    kind: "equation",
    supplement: "Wzór",
    gap: 1.5em
  )
}

#{
  show raw: set text(size: 0.9em)
  figure(
    [```rust
    for (i, row) in x.iter().enumerate() {
      for (j, &value) in row.iter().enumerate() {
        if max[j] - min[j] == 0.0 {
          x_norm[i][j] = 0.0; // Avoid division by zero
        } else {
          // Normalize to range [-1, 1]
          x_norm[i][j] = -1.0 + 2.0 * (value - min[j]) / (max[j] - min[j]);
        }
      }
    }
    ```],
    caption: "Normalizacja danych",
  )
}
== Podział na zbiory treningowe i testowe

\

Podział danych na zbiory treningowe i testowe jest kluczowym elementem w procesie uczenia maszynowego, ponieważ pozwala
na ocenę skuteczności modelu na nowych, nie widzianych wcześniej danych. W moim przypadku zdecydowałem się na podział
danych w stosunku $80%$ do $20%$, gdzie $80%$ danych zostało wykorzystane do treningu, a $20%$ do testowania.
W późniejszych etapach zmieniałem ten podział na $70%$ do $30%$ w celach eksperymentów.

Podział danych na zbiory treningowe i testowe pozwala na ocenę skuteczności modelu na nowych, nie widzianych wcześniej
danych. W ten sposób można sprawdzić, jak dobrze model generalizuje swoje umiejętności na nowych danych, a nie tylko
na tych, które były obecne w zestawie treningowym.

W tym celu napisałem funkcję `split_data`, która dokonuje losowego podziału danych na zbiory treningowe i testowe. Po
podziale dane są dodatkowo sortowane według klasy, aby zapewnić równomierne rozłożenie próbek w zbiorach treningowym
i testowym.

#{
  show raw: set text(size: 0.9em)
  figure(
    [```rust
    fn split_data(
      x: Vec<Vec<f32>>,
      y_t: Vec<i32>
    ) -> (Vec<Vec<f32>>, Vec<i32>, Vec<Vec<f32>>, Vec<i32>) {
      let mut rng = thread_rng();
      let mut combined: Vec<(Vec<f32>, i32)> = x.into_iter().zip(y_t.into_iter()).collect();
      combined.shuffle(&mut rng);

      let num_records = combined.len();
      let num_train = (num_records as f32 * 0.8) as usize;

      // Split data into training and testing sets
      let (train_data, test_data): (Vec<_>, Vec<_>) = combined
        .into_iter()
        .enumerate()
        .partition(|&(i, _)| i >= num_train);

      // Sort by y_t class and unzip to separate x and y_t
      let mut train_sorted: Vec<_> = train_data.into_iter().map(|(_, data)| data).collect();
      train_sorted.sort_by_key(|&(_, y)| y);
      let (x_train, y_t_train): (Vec<_>, Vec<_>) = train_sorted.into_iter().unzip();

      let mut test_sorted: Vec<_> = test_data.into_iter().map(|(_, data)| data).collect();
      test_sorted.sort_by_key(|&(_, y)| y);
      let (x_test, y_t_test): (Vec<_>, Vec<_>) = test_sorted.into_iter().unzip();

      (x_train, y_t_train, x_test, y_t_test)
    }
    ```],
    caption: "Podział danych na zbiory treningowe i testowe",
  )
}

#pagebreak()

== Zapis danych do plików

\

Tak przygotowane dane zostały zapisane do plików w formacie PKL. Do zserializowania danych wykorzystałem bibliotekę
`serde-pickle` z pakietu `serde`, która pozwala na serializację i deserializację danych w formacie PKL. Dane zostały
zapisane w postaci czterech plików: `x_train.pkl`, `y_t_train.pkl`, `x_test.pkl` i `y_t_test.pkl`.

#{
  show raw: set text(size: 0.9em)
  figure(
    [```rust
    /// Save `x` and `y_t` to disk in pickle format.
    fn dump_to_pkl(x: Vec<Vec<f32>>, y_t: Vec<i32>, prefix: &str) {
      // Create BTreeMaps to serialize
      let mut x_map = BTreeMap::new();
      let mut y_map = BTreeMap::new();
      x_map.insert(String::from("x"), x);
      y_map.insert(String::from("y_t"), y_t);

      // Serialize to pickle format
      let x_serialized = serde_pickle::to_vec(&x_map, Default::default()).unwrap();
      let y_serialized = serde_pickle::to_vec(&y_map, Default::default()).unwrap();

      // Save to disk
      std::fs::write(format!("./data/x_{}.pkl", prefix), &x_serialized).unwrap();
      std::fs::write(format!("./data/y_t_{}.pkl", prefix), &y_serialized).unwrap();
    }
    ```],
    caption: "Funkcja zapisująca dane do plików PKL",
  )
}

== Podsumowanie

\

Przygotowanie danych do trenowania modelu klasyfikacji win wymagało kilku istotnych kroków, takich jak czyszczenie,
normalizacja, podział na zbiory treningowe i testowe oraz zapis do plików. Dzięki tym operacjom dane są gotowe do
dalszego przetwarzania i trenowania modelu.

#figure(
  image("./images/data-table.jpg"),
  caption: "Tabela z częścią danych przygotowanych do trenowania modelu",
)

#pagebreak()

= Trenowanie modelu

\

Po przygotowaniu danych przyszedł czas na trenowanie modelu. W tym projekcie zdecydowałem się na wykorzystanie
biblioteki `Burn` do implementacji modelu, jak i jego trenowania.

Przed samym przystąpieniem do trenowania modelu, podtrzebne jest zdefiniowanie architektury sieci neuronowej,
przygotowanie danych treningowych i testowych oraz wybór odpowiednich hiperparametrów, takich jak współczynnik uczenia,
liczba epok czy rozmiar wsadu (_batch size_).

== Przygotowanie danych

\

Trenowanie modelu w bibliotece `Burn` wymaga tzw. _Batcherów_ (plik #link(<batcher>)[`batcher.rs`] w części skryptowej),
które są odpowiedzialne za dostarczanie danych do modelu w postaci wsadów (_batches_). _Batcher_ przyjmuje strukture
_Dataset_ (plik #link(<dataset>)[`dataset.rs`], w części skryptowej) jako dane wejściowe i dzieli je na wsady o
określonym rozmiarze.

W moim przypadku, struktura `WineDataset` przechowuje dane treningowe i testowe, które zostały wcześniej przygotowane
i zapisane do plików PKL. Następnie, `WineBatcher` dzieli te dane na wsady `WineBatch`, które są przekazywane do modelu
podczas treningu.

=== Implementacja tensorów

\

Ważnym elementem w trenowaniu modelu jest implementacja tensorów, które są podstawowymi strukturami danych w
bibliotece `Burn`. Tensor reprezentuje wielowymiarowy wektor lub macierz, który jest przechowywany w pamięci urządzenia.
W przpadku mojego programu, tensory tworzone są w funkcji `batch` w strukturze `WineBatcher`. Przechowują one dane
wejściowe i wyjściowe dla modelu, które są przekazywane do sieci neuronowej.

Pierwsze tensor jest tworzony dla każdego wina z danych treningowych, a drugi tensor przechowuje etykietę klasy dla
tego wina. Następnie, te tensory są łączone w jeden tensor dla danych wejściowych i wyjściowych, który jest przekazywany
bezpośrednio do modelu.

#{
  show raw: set text(size: 0.9em)
  figure(
    [```rust
    impl<B: Backend> Batcher<WineItem, WineBatch<B>> for WineBatcher<B> {
      fn batch(&self, data: Vec<WineItem>) -> WineBatch<B> {
        let x = data
          .iter()
          .map(|wine| {
            Tensor::<B, 2>::from_data(
              [[
                wine.alcohol,
                wine.malic_acid,
                wine.ash,
                wine.alcalinity_of_ash,
                wine.magnesium,
                wine.total_phenols,
                wine.flavanoids,
                wine.nonflavanoid_phenols,
                wine.proanthocyanins,
                wine.color_intensity,
                wine.hue,
                wine.od280_od315_of_diluted_wines,
                wine.proline,
              ]],
              &self.device,
            )
          })
          .collect::<Vec<_>>();

        let y = data
          .iter()
          .map(|wine| Tensor::<B, 1, Int>::from_data([wine.class], &self.device))
          .collect::<Vec<_>>();

        let x = Tensor::<B, 2>::cat(x, 0).to_device(&self.device);
        let y = Tensor::<B, 1, Int>::cat(y, 0).to_device(&self.device);

        WineBatch { x, y }
      }
    }
    ```],
    caption: [Implementacji funkcji `batch`, której wymaga struktura `WineBatcher`],
  )
}









= Skrypt

#show figure: set block(breakable: true)
#show raw: set text(size: 0.75em)
#figure(
  [```rust
  use cli_table::*;
  use si_project::dataset::WineItem;
  use std::collections::BTreeMap;
  use std::default::Default;
  use std::fs::read_to_string;

  fn main() {
    let data = load_data_file();
    let wines = parse_data(data);

    // 1. Extract `x` and `y_t`
    let (x, y_t) = extract_x_and_y_t(&wines);

    // 2. Normalize `x` -> `x_norm`
    let x_norm = normalize_x(&x);

    // Sorting by `y_t` is unnecessary for this dataset. Data is already sorted by class.

    // 3. Split data into training and testing sets
    let (x_train, y_t_train, x_test, y_t_test) = split_data(x_norm, y_t);

    // 3. Display data in a table
    println!("Data test:");
    table_data(&x_train, &y_t_train);
    println!("\n\n\nData train:");
    table_data(&x_test, &y_t_test);

    // 4. Save everything to an PKL file
    dump_to_pkl(x_train, y_t_train, "train");
    dump_to_pkl(x_test, y_t_test, "test");

    println!("Data processing and saving completed.");
  }

  /// Load data file into a `String`.
  fn load_data_file() -> String {
    read_to_string("./data/wine.data").unwrap()
  }

  /// Parse raw data into a Vector of `Wine` structs.
  fn parse_data(data: String) -> Vec<WineItem> {
    data.lines()
      .map(|line| {
        let mut wine_data = line.split(',').map(|s| s.parse::<f32>().unwrap());
        WineItem {
          class: wine_data.next().unwrap() as i32,
          alcohol: wine_data.next().unwrap(),
          malic_acid: wine_data.next().unwrap(),
          ash: wine_data.next().unwrap(),
          alcalinity_of_ash: wine_data.next().unwrap(),
          magnesium: wine_data.next().unwrap(),
          total_phenols: wine_data.next().unwrap(),
          flavanoids: wine_data.next().unwrap(),
          nonflavanoid_phenols: wine_data.next().unwrap(),
          proanthocyanins: wine_data.next().unwrap(),
          color_intensity: wine_data.next().unwrap(),
          hue: wine_data.next().unwrap(),
          od280_od315_of_diluted_wines: wine_data.next().unwrap(),
          proline: wine_data.next().unwrap(),
        }
      })
      .collect()
  }

  /// Extract `x` (Wine attributes 1-13) and `y_t` (class attribute).
  fn extract_x_and_y_t(wines: &[WineItem]) -> (Vec<Vec<f32>>, Vec<i32>) {
    let num_records = wines.len();
    let mut x = vec![vec![0.0; 13]; num_records];
    let mut y_t = vec![0; num_records];

    for (i, wine) in wines.iter().enumerate() {
      x[i][0] = wine.alcohol;
      x[i][1] = wine.malic_acid;
      x[i][2] = wine.ash;
      x[i][3] = wine.alcalinity_of_ash;
      x[i][4] = wine.magnesium;
      x[i][5] = wine.total_phenols;
      x[i][6] = wine.flavanoids;
      x[i][7] = wine.nonflavanoid_phenols;
      x[i][8] = wine.proanthocyanins;
      x[i][9] = wine.color_intensity;
      x[i][10] = wine.hue;
      x[i][11] = wine.od280_od315_of_diluted_wines;
      x[i][12] = wine.proline;

      y_t[i] = wine.class;
    }

    (x, y_t)
  }

  /// Normalize `x` (array of wine attributes 1-13).
  fn normalize_x(x: &Vec<Vec<f32>>) -> Vec<Vec<f32>> {
    let num_columns = x[0].len();

    let mut min = vec![f32::MAX; num_columns];
    let mut max = vec![f32::MIN; num_columns];

    for row in x.iter() {
      for (j, &value) in row.iter().enumerate() {
        if value < min[j] {
          min[j] = value;
        }
        if value > max[j] {
          max[j] = value;
        }
      }
    }

    let mut x_norm = x.clone();
    for (i, row) in x.iter().enumerate() {
      for (j, &value) in row.iter().enumerate() {
        if max[j] - min[j] == 0.0 {
          x_norm[i][j] = 0.0; // Avoid division by zero
        } else {
          // Normalize to range [-1, 1]
          x_norm[i][j] = -1.0 + 2.0 * (value - min[j]) / (max[j] - min[j]);
        }
      }
    }

    x_norm
  }

  /// Display data in a table.
  fn table_data(x: &Vec<Vec<f32>>, y_t: &Vec<i32>) {
    let mut table = Vec::new();

    // Add data to table
    for (i, row) in x.iter().enumerate() {
      let mut row_data = Vec::new();
      row_data.push(y_t[i].to_string());
      for &value in row.iter() {
          row_data.push(value.to_string());
      }
      table.push(row_data);
    }

    // Add header to table
    let table = table.table().title(vec![
      "y_t".cell().bold(true),
      "alcohol".cell().bold(true),
      "malic_acid".cell().bold(true),
      "ash".cell().bold(true),
      "alcalinity_of_ash".cell().bold(true),
      "magnesium".cell().bold(true),
      "total_phenols".cell().bold(true),
      "flavanoids".cell().bold(true),
      "nonflavanoid_phenols".cell().bold(true),
      "proanthocyanins".cell().bold(true),
      "color_intensity".cell().bold(true),
      "hue".cell().bold(true),
      "od280_od315_of_diluted_wines".cell().bold(true),
      "proline".cell().bold(true),
    ]);

    print_stdout(table).unwrap();
  }

  /// Save `x` and `y_t` to disk in pickle format.
  fn dump_to_pkl(x: Vec<Vec<f32>>, y_t: Vec<i32>, prefix: &str) {
    // Create BTreeMaps to serialize
    let mut x_map = BTreeMap::new();
    let mut y_map = BTreeMap::new();
    x_map.insert(String::from("x"), x);
    y_map.insert(String::from("y_t"), y_t);

    // Serialize to pickle format
    let x_serialized = serde_pickle::to_vec(&x_map, Default::default()).unwrap();
    let y_serialized = serde_pickle::to_vec(&y_map, Default::default()).unwrap();

    // Save to disk
    std::fs::write(format!("./data/x_{}.pkl", prefix), &x_serialized).unwrap();
    std::fs::write(format!("./data/y_t_{}.pkl", prefix), &y_serialized).unwrap();
  }

  /// Split data into training and testing sets.
  use rand::seq::SliceRandom;
  use rand::thread_rng;

  fn split_data(
      x: Vec<Vec<f32>>,
      y_t: Vec<i32>,
  ) -> (Vec<Vec<f32>>, Vec<i32>, Vec<Vec<f32>>, Vec<i32>) {
    let mut rng = thread_rng();
    let mut combined: Vec<(Vec<f32>, i32)> = x.into_iter().zip(y_t.into_iter()).collect();
    combined.shuffle(&mut rng);

    let num_records = combined.len();
    let num_train = (num_records as f32 * 0.7) as usize;

    // Split data into training and testing sets
    let (train_data, test_data): (Vec<_>, Vec<_>) = combined
      .into_iter()
      .enumerate()
      .partition(|&(i, _)| i >= num_train);

    // Sort by y_t class
    let mut train_sorted: Vec<_> = train_data.into_iter().map(|(_, data)| data).collect();
    train_sorted.sort_by_key(|&(_, y)| y);
    let (x_train, y_t_train): (Vec<_>, Vec<_>) = train_sorted.into_iter().unzip();

    let mut test_sorted: Vec<_> = test_data.into_iter().map(|(_, data)| data).collect();
    test_sorted.sort_by_key(|&(_, y)| y);
    let (x_test, y_t_test): (Vec<_>, Vec<_>) = test_sorted.into_iter().unzip();

    (x_train, y_t_train, x_test, y_t_test)
  }
  ```],
  caption: `prepare_data.rs`,
)<prepare_data>

#figure(
  [```rust
  use burn::data::dataset::{Dataset, InMemDataset};
  use serde::{Deserialize, Serialize};
  use std::collections::BTreeMap;
  use std::fs::File;
  use std::io;

  #[derive(Debug, PartialEq, Clone, Serialize, Deserialize)]
  pub struct WineItem {
    #[serde(rename = "class")]
    pub class: i32,

    #[serde(rename = "Alcohol")]
    pub alcohol: f32,

    #[serde(rename = "Malic acid")]
    pub malic_acid: f32,

    #[serde(rename = "Ash")]
    pub ash: f32,

    #[serde(rename = "Alcalinity of ash")]
    pub alcalinity_of_ash: f32,

    #[serde(rename = "Magnesium")]
    pub magnesium: f32,

    #[serde(rename = "Total phenols")]
    pub total_phenols: f32,

    #[serde(rename = "Flavanoids")]
    pub flavanoids: f32,

    #[serde(rename = "Nonflavanoid phenols")]
    pub nonflavanoid_phenols: f32,

    #[serde(rename = "Proanthocyanins")]
    pub proanthocyanins: f32,

    #[serde(rename = "Color intensity")]
    pub color_intensity: f32,

    #[serde(rename = "Hue")]
    pub hue: f32,

    #[serde(rename = "OD280/OD315 of diluted wines")]
    pub od280_od315_of_diluted_wines: f32,

    #[serde(rename = "Proline")]
    pub proline: f32,
  }

  pub struct WineDataset {
    pub(crate) dataset: InMemDataset<WineItem>,
  }

  impl WineDataset {
    pub fn subset(&self, indices: &[usize]) -> Self {
      let data: Vec<WineItem> = indices
        .iter()
        .map(|&i| self.dataset.get(i).unwrap().clone())
        .collect();
      Self {
        dataset: InMemDataset::new(data),
      }
    }
  }

  impl WineDataset {
    pub fn from_pkl(split: &str) -> Result<Self, io::Error> {
      let x_file = File::open(format!("./data/x_{}.pkl", split))?;
      let y_file = File::open(format!("./data/y_t_{}.pkl", split))?;

      let x_map: BTreeMap<String, Vec<Vec<f32>>> =
        serde_pickle::from_reader(x_file, Default::default())
          .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;
      let y_map: BTreeMap<String, Vec<i32>> =
        serde_pickle::from_reader(y_file, Default::default())
          .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;

      let mut data = Vec::new();

      for (key, x_values) in x_map.get("x").unwrap().iter().enumerate() {
        if let Some(y_values) = y_map.get("y_t").unwrap().get(key) {
          let wine = WineItem {
            class: *y_values,
            alcohol: x_values[0],
            malic_acid: x_values[1],
            ash: x_values[2],
            alcalinity_of_ash: x_values[3],
            magnesium: x_values[4],
            total_phenols: x_values[5],
            flavanoids: x_values[6],
            nonflavanoid_phenols: x_values[7],
            proanthocyanins: x_values[8],
            color_intensity: x_values[9],
            hue: x_values[10],
            od280_od315_of_diluted_wines: x_values[11],
            proline: x_values[12],
          };
          data.push(wine);
        }
      }

      let dataset = InMemDataset::new(data);

      Ok(Self { dataset })
    }

    pub fn train() -> Self {
      Self::from_pkl("train").unwrap()
    }

    pub fn test() -> Self {
      Self::from_pkl("test").unwrap()
    }
  }

  impl Dataset<WineItem> for WineDataset {
    fn get(&self, index: usize) -> Option<WineItem> {
      self.dataset.get(index)
    }

    fn len(&self) -> usize {
      self.dataset.len()
    }
  }
  ```],
  caption: `dataset.rs`
)<dataset>

#figure(
  [```rust
  use crate::dataset::WineItem;
  use burn::data::dataloader::batcher::Batcher;
  use burn::prelude::{Backend, Int, Tensor};

  #[derive(Clone)]
  pub struct WineBatcher<B: Backend> {
    device: B::Device,
  }

  impl<B: Backend> WineBatcher<B> {
    pub fn new(device: B::Device) -> Self {
      Self { device }
    }
  }

  #[derive(Clone, Debug)]
  pub struct WineBatch<B: Backend> {
    pub x: Tensor<B, 2>,
    pub y: Tensor<B, 1, Int>,
  }

  impl<B: Backend> Batcher<WineItem, WineBatch<B>> for WineBatcher<B> {
    fn batch(&self, data: Vec<WineItem>) -> WineBatch<B> {
      let x = data
        .iter()
        .map(|wine| {
          Tensor::<B, 2>::from_data(
            [[
              wine.alcohol,
              wine.malic_acid,
              wine.ash,
              wine.alcalinity_of_ash,
              wine.magnesium,
              wine.total_phenols,
              wine.flavanoids,
              wine.nonflavanoid_phenols,
              wine.proanthocyanins,
              wine.color_intensity,
              wine.hue,
              wine.od280_od315_of_diluted_wines,
              wine.proline,
            ]],
            &self.device,
          )
        })
        .collect::<Vec<_>>();

      let y = data
        .iter()
        .map(|wine| Tensor::<B, 1, Int>::from_data([wine.class], &self.device))
        .collect::<Vec<_>>();

      let x = Tensor::<B, 2>::cat(x, 0).to_device(&self.device);
      let y = Tensor::<B, 1, Int>::cat(y, 0).to_device(&self.device);

      WineBatch { x, y }
    }
  }
  ```],
  caption: `batcher.rs`
)<batcher>