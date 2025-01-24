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
