use burn::data::dataset::{Dataset, InMemDataset};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

#[derive(Debug, PartialEq, Clone, Serialize, Deserialize)]
pub struct Wine {
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
    dataset: InMemDataset<Wine>,
}

impl WineDataset {
    pub fn from_pkl() -> Result<Self, std::io::Error> {
        // Get dataset from data file
        let x_file = std::fs::File::open("./data/x.pkl").unwrap();
        let x_map: BTreeMap<String, Vec<Vec<f32>>> =
            serde_pickle::from_reader(x_file, Default::default()).unwrap();
        let y_file = std::fs::File::open("./data/y_t.pkl").unwrap();
        let y_map: BTreeMap<String, Vec<i32>> =
            serde_pickle::from_reader(y_file, Default::default()).unwrap();

        // Build dataset from pickle file
        let mut data = Vec::new();

        for (key, x_values) in x_map.get("x").unwrap().iter().enumerate() {
            if let Some(y_values) = y_map.get("y_t").unwrap().get(key) {
                let wine = Wine {
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

        let dataset = Self { dataset };

        Ok(dataset)
    }
}

// Implement the `Dataset` trait which requires `get` and `len`
impl Dataset<Wine> for WineDataset {
    fn get(&self, index: usize) -> Option<Wine> {
        self.dataset.get(index)
    }

    fn len(&self) -> usize {
        self.dataset.len()
    }
}
