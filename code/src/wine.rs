use burn::data::dataloader::batcher::Batcher;
use burn::data::dataset::{Dataset, InMemDataset};
use burn::prelude::Backend;
use burn::tensor::{Int, Tensor};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use std::fmt;

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
    pub fn from_pkl(split: &str) -> Result<Self, std::io::Error> {
        // Get dataset from data file
        let x_file = std::fs::File::open(format!("./data/x_{}.pkl", split))?;
        let x_map: BTreeMap<String, Vec<Vec<f32>>> =
            serde_pickle::from_reader(x_file, Default::default()).unwrap();
        let y_file = std::fs::File::open(format!("./data/y_t_{}.pkl", split))?;
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

    pub fn train() -> Self {
        Self::from_pkl("train").unwrap()
    }

    pub fn test() -> Self {
        Self::from_pkl("test").unwrap()
    }
}

impl fmt::Debug for WineDataset {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("WineDataset")
            .field("dataset", &"InMemDataset<Wine>")
            .finish()
    }
}

impl Clone for WineDataset {
    fn clone(&self) -> Self {
        Self {
            dataset: InMemDataset::new(self.dataset.iter().collect::<Vec<_>>().clone()),
        }
    }
}

/// Implement the `Dataset` trait which requires `get` and `len`
impl Dataset<Wine> for WineDataset {
    fn get(&self, index: usize) -> Option<Wine> {
        self.dataset.get(index)
    }

    fn len(&self) -> usize {
        self.dataset.len()
    }
}

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

impl<B: Backend> Batcher<Wine, WineBatch<B>> for WineBatcher<B> {
    fn batch(&self, data: Vec<Wine>) -> WineBatch<B> {
        let x = data
            .iter()
            .map(|wine| {
                Tensor::<B, 2>::from_data([[
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
                ]], &self.device)
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
