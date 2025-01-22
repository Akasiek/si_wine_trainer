use si_project::wine::Wine;
use std::collections::BTreeMap;
use std::default::Default;
use std::fs::read_to_string;
use cli_table::*;

fn main() {
    let data = load_data_file();
    let wines = parse_data(data);

    // 1. Extract `x` and `y_t`
    let (x, y_t) = extract_x_and_y_t(&wines);

    // 2. Normalize `x` -> `x_norm`
    let x_norm = normalize_x(&x);

    // Sorting by `y_t` is unnecessary for this dataset. Data is already sorted by class.

    // 3. Display data in a table
    println!("Data before normalization:");
    table_data(&x, &y_t);
    println!("\n\n\nData after normalization:");
    table_data(&x_norm, &y_t);

    let (x_train, y_t_train, x_test, y_t_test) = split_data(x_norm, y_t);

    // 5. Save everything to an HDF5 file
    dump_to_pkl(x_train, y_t_train, "train");
    dump_to_pkl(x_test, y_t_test, "test");

    println!("Data processing and saving completed.");

}

/// Load data file into a `String`.
fn load_data_file() -> String {
    read_to_string("./data/wine.data").unwrap()
}

/// Parse raw data into a Vector of `Wine` structs.
fn parse_data(data: String) -> Vec<Wine> {
    data.lines()
        .map(|line| {
            let mut wine_data = line.split(',').map(|s| s.parse::<f32>().unwrap());
            Wine {
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
fn extract_x_and_y_t(wines: &[Wine]) -> (Vec<Vec<f32>>, Vec<i32>) {
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
fn split_data(x: Vec<Vec<f32>>, y_t: Vec<i32>) -> (Vec<Vec<f32>>, Vec<i32>, Vec<Vec<f32>>, Vec<i32>) {
    let num_records = x.len();
    let num_train = (num_records as f32 * 0.8) as usize;

    let x_train = x.iter().take(num_train).cloned().collect();
    let y_t_train = y_t.iter().take(num_train).cloned().collect();
    let x_test = x.iter().skip(num_train).cloned().collect();
    let y_t_test = y_t.iter().skip(num_train).cloned().collect();

    (x_train, y_t_train, x_test, y_t_test)
}